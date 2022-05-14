# Linear Predictive Coding

***

In this project, Linear Predictive Coding (LPC) has been implemented and studied through MATLAB Graphical User Interface (GUI).

## Introduction:-

Linear predictive coding (LPC) is a widely used technique in audio signal processing, especially in speech signal processing. It has been particular used to estimate the
basic parameters of speech as pitch (through frequency) and intensity (through loudness).

<img src="https://user-images.githubusercontent.com/87858655/168421124-22a20a35-60b9-4661-90c6-44a9247e8913.png" height="300" width="750" >

We can formulate the relation between the input and output as,

<img src="https://user-images.githubusercontent.com/87858655/168421168-2f7c65a7-2b55-4221-8ceb-c8f17cba74ba.png" height="200" width="550" >

To find out $a_{k}$, the above equation is converted to matrix form. Speech samples can be approximated as a linear combination of the past samples by minimizing the error. The solution of choice for LPC is *Least Squares*, for which those values of $a_{k}$ is chosen that minimizes ||$e(n)^{2}$||, the power of the error of estimation or residual **e**.

The usual approach in audio processing for encoding the audio signal after it is segmented is to use a technique called *Overlap-add (OLA)*. For OLA, we window the signal with a *window function* $w(n)$ that has a constant OLA property.

The signal is decoded by running the filter coefficients $a_{k}$ through the LPC model and using variance to control the source, and then the decoded windowed signals is overlap-added to obtain the full signal.

## Methodology:-

A Graphical User Interface (GUI) in MATLAB was designed to study the working of LPC.

### Recording the Input Audio Signal

* The user is asked to enter the duration of input speech signal 'x' in seconds.
* When the 'Record' push button is pressed, the audio signal gets recorded and saved as a file.
* When the 'Play' push button is pressed, the original audio signal is played and gets plotted.

### User Inputs and Choices

* The user is asked to enter the length of audio segment in ms to divide the recorded speech signal into smaller segments.
* The percentage of overlap is entered by the user.
* The user can choose from any of the 4 window functions -  Hanning, Hamming, Barlett and Blackman.
* The user can choose from any of the 4 Linear Predictor Filters of orders 12, 48, 72 and 96.

### Encoding the speech signal and Computing Pitch

* The sampled input speech signal is applied to an analyzer, which computes the parameters of the speech signal to be transmitted to the synthesizer, ie, the filter coefficients of LP Filter and the pitch of each segment. 
* The pitch of each segment of the speech segment is plotted.

### Decoding the signal with and without Pitch

* This speech synthesizer reconstructs the approximated speech signal. The input provided to the encoder is the comparison between the sampled signal and the approximated signal with the parameters. 
* This encoder forms the digital signal known as LPC output.
* The LPC output is provided to the Low Pass Filter, which reconstructs the audio signal $x(t)$ by performing the interpolation of samples in the input, with and without using the information of pitch.

## Results:-

### Original Speech Signal:

![Pic](https://user-images.githubusercontent.com/87858655/168421184-2d94c1f6-90f6-48fc-bfed-2633c504c0ba.png)

### Plot of Pitch:

![Pic](https://user-images.githubusercontent.com/87858655/168421199-f02d091c-da40-44be-bec4-d739c76d4eba.png)

### Reconstruction of Speech Signal Without Pitch

![Pic](https://user-images.githubusercontent.com/87858655/168421227-1b2a71ae-3252-4b95-b1cd-0db25b704570.png)

### Reconstruction of Speech Signal With Pitch

![Pic](https://user-images.githubusercontent.com/87858655/168421246-c11e4202-3980-4414-a316-690f636274cb.png)

## Analysis of Reconstructed Speech:-

### LP Filter of Order 12:

The quality of the reconstructed speech signal output was relatively low. Due to higher rate of compression, the output speech signal was distorted and less clear. The pitch of output signal was also low, as the output sounded deeper than the input speech.

### LP Filter of Order 48:

The quality of output speech signal increases as the number of previous samples (order of the LP filter) for prediction increases. Due to a lesser rate of compression the reconstructed speech signal was less distorted and more legible than before. The pitch of output was also marginally higher.

### LP Filter of Order 72:

The speech is more understandable due to very less distortion since the rate of compression is less. Thus, the overall output quality is better for the LP filter of order 72.

### LP Filter of Order 96:

Quality of output speech signal is the best for the LP filter of order 96. Since 96 previous samples have been considered to reconstruct the output, the compression rate is less, and thus the distortion of the output is also less. The output quality is clearer as compared to the previous lower order filters.

### Computation of Amount of Compression achieved with Filters of different Orders:

| Order of LP Filter | Without Pitch Detection | With Pitch Detection |
| -------- | -------- | -------- |
| 12    | 9.3 to 1     | 8.6 to 1     |
| 48     | 2.45 to 1     | 2.35 to 1     |
| 72     | 1.65 to 1     | 1.57 to 1     |
| 96     | 1.24 to 1     | 1.20 to 1     |

### Comparison of Quality of Speech Reconstruction With and Without Pitch Detection:

* With Pitch Detection,
    * The rate of compression of the input speech signal was lower
    * The distortion of the output was lesser
    * The quality of the reconstructed output speech signal was better
    * The speech signal was clearer and the nasality tone of the output was more prominent.

* Without Pitch Detection,
    * The depth/pitch of the output speech was considerably higher.

This observation was true irrespective of the order of the LP filter being used. However, as the order of the filter increased, the quality of speech signal output also increased.

## References:-

[Linear Predictive Coding is All-Pole Resonance Modeling by Hyung-Suk Kim](https://ccrma.stanford.edu/~hskim08/lpc/)

