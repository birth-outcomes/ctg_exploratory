import matplotlib.pyplot as plt
import numpy as np
from scipy import interpolate


def plot_power_spectrum(df, col):
    """This function will calculate & remove the noise in signal
    using Fourier Transform

    Args:
        df ([pandas]): dataframe
        col ([str]): column name from which noise to removed
    """
    n = len(df)
    dt = 0.25  # sampling frequenc=y
    fhat = np.fft.fft(df[col], n)  # Compute FFT
    PSD = fhat * np.conj(fhat) / n  # Power spectrum
    freq = (1/(dt*n)) * np.arange(n)  # Create X- axis of ferquencies
    L = np.arange(1, np.floor(n/15), dtype='int')

    _, axs = plt.subplots(3, 1, figsize=(25, 15))

    plt.sca(axs[0])
    plt.title('Original Signal (noisy)')
    plt.plot(df['seconds'], df[col], label='Noisy')
    plt.legend()

    plt.sca(axs[1])
    plt.plot(freq[L], PSD[L])
    plt.xlim(freq[L[0]], freq[L[-1]])
    plt.title('Power Spectrum')
    # plt.show()

    indices = PSD > 0.00001  # finad all frequecies larger then power spectrum
    PSDclean = PSD * indices  # zero out all other indices
    fhat = indices * fhat  # zero out all fourier coff in Y
    ffilt = np.fft.ifft(fhat)  # inverse FFT for filtered time signal

    plt.sca(axs[2])
    plt.title('DeNoised Signal')
    plt.plot(df['seconds'], ffilt, label='DeNoised')
    plt.legend()

    plt.show()


def f(df, x):
    x_points = df['seconds']
    y_points = df['FHR']

    tck = interpolate.splrep(x_points, y_points)
    return interpolate.splev(x, tck)


def plot_interpolated_df(df):

    _, axs = plt.subplots(2, 1, figsize=(25, 12))
    plt.sca(axs[0])
    plt.plot(df['seconds'], df['FHR'], label='Noisy')
    plt.legend()

    plt.sca(axs[1])
    plt.plot(df.seconds, df.FHR_denoised, label='DeNoised')
    plt.legend()

    plt.show()


def interpolate_df(df, col):
    """Interploation filling the data using interpolation
     of we have 0 in less then 30 rows (represents 30 sec)

    Args:
        df ([pandas]): dataframe
        col ([str]): column name from which noise to removed

    Returns:
        [pandas]: interpolated df
    """
    t = 30
    values = list(df[col])
    flag = None
    k = len(df)
    i = 0

    while i <= k-t:
        x = df[col][i]
        if x >= 50:
            pass
        else:
            count = 0
            while True:
                if df[col][i+count] == 0:
                    count += 1
                else:
                    flag = 'yes'
                    break
                if count == t+1:
                    flag = 'no'
                    #shift = 0
                    i += count
                    while i <= k-t:
                        if df[col][i] == 0:
                            i += 1
                        else:
                            break
                    #i += shift
                    break
            if flag == 'yes':
                values[i] = f(df, x)
        i += 1

    df[col+'_denoised'] = values
    return df
