from numpy import loadtxt
from tensorflow.keras.models import load_model
from datetime import timedelta
from sklearn.preprocessing import MinMaxScaler
from scipy.interpolate import interp1d
import numpy as np
import pandas as pd

from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def home():
    new_model_td = load_model('model.h5')
    new_model_ph = load_model('model_ph.h5')
    new_model_tds = load_model('model_tds.h5')
    new_model_tempm = load_model('model_tempm.h5')

    data = pd.read_csv('finaldata.csv')

    data['datetime_utc'] = pd.to_datetime(data['datetime_utc'])
    data.set_index('datetime_utc', inplace=True)
    data = data.resample('D').mean()
    # data.head

    data_td = data[['_td']]
    data_tds = data[[' _tds']]
    data_ph = data[[' _ph']]
    data_tempm = data[[' _tempm']]

    data_tempm[' _tempm'] = data_tempm[' _tempm'].interpolate()
    data_tds[' _tds'] = data_tds[' _tds'].interpolate()
    data_ph[' _ph'] = data_ph[' _ph'].interpolate()
    data_td['_td'] = data_td['_td'].interpolate()

    df_td = data_td.copy()
    df_tds = data_tds.copy()
    df_tempm = data_tempm.copy()
    df_ph = data_ph.copy()

    data_td = data_td.values
    data_td = data_td.astype('float32')
    data_tds = data_tds.values
    data_tds = data_tds.astype('float32')
    data_ph = data_ph.values
    data_ph = data_ph.astype('float32')
    data_tempm = data_tempm.values
    data_tempm = data_tempm.astype('float32')

    scaler = MinMaxScaler(feature_range=(-1, 1))
    sc_td = scaler.fit_transform(data_td)
    sc_tds = scaler.fit_transform(data_tds)
    sc_ph = scaler.fit_transform(data_ph)
    sc_tempm = scaler.fit_transform(data_tempm)

    timestep = 30

    X_td = []
    Y_td = []
    X_ph = []
    Y_ph = []
    X_tds = []
    Y_tds = []
    X_tempm = []
    Y_tempm = []

    for i in range(len(sc_td) - (timestep)):
        X_td.append(sc_td[i:i + timestep])
        Y_td.append(sc_td[i + timestep])

        X_tds.append(sc_tds[i:i + timestep])
        Y_tds.append(sc_tds[i + timestep])

        X_ph.append(sc_ph[i:i + timestep])
        Y_ph.append(sc_ph[i + timestep])

        X_tempm.append(sc_tempm[i:i + timestep])
        Y_tempm.append(sc_tempm[i + timestep])

    X_td = np.asanyarray(X_td)
    Y_td = np.asanyarray(Y_td)

    X_tds = np.asanyarray(X_tds)
    Y_tds = np.asanyarray(Y_tds)

    X_ph = np.asanyarray(X_ph)
    Y_ph = np.asanyarray(Y_ph)

    X_tempm = np.asanyarray(X_tempm)
    Y_tempm = np.asanyarray(Y_tempm)

    k = 7300

    Xtrain_td = X_td[:k, :, :]
    Xtest_td = X_td[k:, :, :]
    Ytrain_td = Y_td[:k]
    Ytest_td = Y_td[k:]

    Xtrain_tds = X_tds[:k, :, :]
    Xtest_tds = X_tds[k:, :, :]
    Ytrain_tds = Y_tds[:k]
    Ytest_tds = Y_tds[k:]

    Xtrain_tempm = X_tempm[:k, :, :]
    Xtest_tempm = X_tempm[k:, :, :]
    Ytrain_tempm = Y_tempm[:k]
    Ytest_tempm = Y_tempm[k:]

    Xtrain_ph = X_ph[:k, :, :]
    Xtest_ph = X_ph[k:, :, :]
    Ytrain_ph = Y_ph[:k]
    Ytest_ph = Y_ph[k:]

    timestep = 30

    def insert_end(Xin, new_input):
        # print ('Before: \n', Xin , new_input )
        for i in range(timestep - 1):
            Xin[:, i, :] = Xin[:, i + 1, :]
        Xin[:, timestep - 1, :] = new_input
        # print ('After :\n', Xin)
        return Xin

    # this section for unknown future
    # we are getting next 7 steps

    future = 7
    forcast_td = []
    forcast_tds = []
    forcast_tempm = []
    forcast_ph = []

    Xin_td = Xtest_td[-1:, :, :]
    Xin_tds = Xtest_tds[-1:, :, :]
    Xin_ph = Xtest_ph[-1:, :, :]
    Xin_tempm = Xtest_tempm[-1:, :, :]
    time = []

    for i in range(future):
        out_td = new_model_td.predict(Xin_td, batch_size=1)
        out_tds = new_model_tds.predict(Xin_tds, batch_size=1)
        out_ph = new_model_ph.predict(Xin_ph, batch_size=1)
        out_tempm = new_model_tempm.predict(Xin_tempm, batch_size=1)
        forcast_td.append(out_td[0, 0])
        forcast_tds.append(out_tds[0, 0])
        forcast_ph.append(out_ph[0, 0])
        forcast_tempm.append(out_tempm[0, 0])
        Xin_td = insert_end(Xin_td, out_td[0, 0])
        Xin_tds = insert_end(Xin_tds, out_tds[0, 0])
        Xin_ph = insert_end(Xin_ph, out_ph[0, 0])
        Xin_tempm = insert_end(Xin_tempm, out_tempm[0, 0])
        time.append(pd.to_datetime(df_td.index[-1]) + timedelta(days=i + 1))

    forcasted_output_td = np.asanyarray(forcast_td)
    forcasted_output_td = forcasted_output_td.reshape(-1, 1)
    forcasted_output_td = scaler.inverse_transform(forcasted_output_td)

    forcasted_output_tds = np.asanyarray(forcast_tds)
    forcasted_output_tds = forcasted_output_tds.reshape(-1, 1)
    forcasted_output_tds = scaler.inverse_transform(forcasted_output_tds)

    forcasted_output_ph = np.asanyarray(forcast_ph)
    forcasted_output_ph = forcasted_output_ph.reshape(-1, 1)
    forcasted_output_ph = scaler.inverse_transform(forcasted_output_ph)

    forcasted_output_tempm = np.asanyarray(forcast_tempm)
    forcasted_output_tempm = forcasted_output_tempm.reshape(-1, 1)
    forcasted_output_tempm = scaler.inverse_transform(forcasted_output_tempm)

    forcasted_output_td = pd.DataFrame(forcasted_output_td)
    forcasted_output_tds = pd.DataFrame(forcasted_output_tds)
    forcasted_output_ph = pd.DataFrame(forcasted_output_ph)
    forcasted_output_tempm = pd.DataFrame(forcasted_output_tempm)

    return jsonify({'td1': str(forcasted_output_td[0][0]), 'td2': str(forcasted_output_td[0][1]), 'td3': str(forcasted_output_td[0][2]), 'td4': str(forcasted_output_td[0][3]), 'td5': str(forcasted_output_td[0][4]), 'td6': str(forcasted_output_td[0][5]), 'td7': str(forcasted_output_td[0][6]), 'tds1': str(forcasted_output_tds[0][0]), 'tds2': str(forcasted_output_tds[0][1]), 'tds3': str(forcasted_output_tds[0][2]), 'tds4': str(forcasted_output_tds[0][3]), 'tds5': str(forcasted_output_tds[0][4]), 'tds6': str(forcasted_output_tds[0][5]), 'tds7': str(forcasted_output_tds[0][6]), 'ph1': str(forcasted_output_ph[0][0]), 'ph2': str(forcasted_output_ph[0][1]), 'ph3': str(forcasted_output_ph[0][2]), 'ph4': str(forcasted_output_ph[0][3]), 'ph5': str(forcasted_output_ph[0][4]), 'ph6': str(forcasted_output_ph[0][5]), 'ph7': str(forcasted_output_ph[0][6]), 'tempm1': str(forcasted_output_tempm[0][0]), 'tempm2': str(forcasted_output_tempm[0][1]), 'tempm3': str(forcasted_output_tempm[0][2]), 'tempm4': str(forcasted_output_tempm[0][3]), 'tempm5': str(forcasted_output_tempm[0][4]), 'tempm6': str(forcasted_output_tempm[0][5]), 'tempm7': str(forcasted_output_tempm[0][6])})


if __name__ == '__main__':
    app.debug = True
    app.run(host="0.0.0.0")
