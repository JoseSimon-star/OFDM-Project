# OFDM-Project: Coded OFDM transmission on a frequency selective channel

## 1 Introduction
OFDM (Orthogonal Frequency Division Multiplexing) is the modulation of
choice for most nowadays systems. It makes equalization very easy with the
use of the cyclic prefix, and converts the transmission through a wideband
frequency selective channel into multiple parallel and independent frequency
at subchannels. This others a lot of exibility for per-subcarrier processing,
allowing for instance bit and power allocation, coding across the frequencies
to obtain diversity, or simplified MIMO schemes.

One of the main drawbacks associated with OFDM is the issue of synchro-
nization. It is quite sensitive to errors in the carrier frequency (also called
CFO for carrier frequency offset), and requires frame (or block) synchro-
nization to ensure that the FFT operation is applied at the right instants.
Another important drawback of OFDM is the increased PAPR (peak to av-
erage power ratio) and its impact on the non-linear behaviour of the power
amplifiers.
The objective of this project is to study several parts of an OFDM system.
The study is based on mathematical derivations, computer calculations and
simulations (using Matlab for instance). It focuses on the following points:

- Implementation of an OFDM chain on a frequency selective channel
- Adaptive modulation with bit and power allocation
- Channel estimation
- Coding across the frequencies and optimal decoding.

## 2 Context: OFDM transmission
For all the steps of this project, we consider a common OFDM transmission
with the following characteristics. The number of subcarriers is equal to
N = 128. The subcarriers are assumed to be modulated around a carrier
frequency of 2 GHz, and with subcarrier spacing 15 kHz. The cyclic prefix is
fixed at L = 16 samples. The assumptions on the channel will be different for
each part but in all cases, the cyclic prefix is assumed to be long enough (and
the frame synchronization sufficiently accurate) so that the transmission is
performed without inter-carrier and inter-symbol interference.
 ### 2.1 Step 1: Basic OFDM chain
As an initial step in the project, you are required to simulate a basic OFDM
chain on an ideal AWGN channel, using computer simulations. The simulations should generate random input symbols using 4-QAM constellation, implement all the digital operations of the OFDM communication chain,and compute the bit error rate. In this first step, the channel is a simple AWGN channel. Pay particular attention to the computation of the Es/N0 ratio. The simulation should be able to be run for different values of this
parameter and should thus be able to recover the standard BER vs. Es/N0 curve.

## 3 Transceiver optimization
### 3.1 Step 2: Resource allocation
The second step aims at implementing the resource allocation procedure that can take place in an adaptive OFDM transmission. When channel knowledge is available at the transmitter, the powers pk and the number of bits bk (adaptive modulation) associated with each subcarrier k = 0; : : : ;N-1 can be optimized. We consider QAM modulation and a target symbol error rate of 10􀀀5 on each subcarrier. For this part, one particular channel realization (normalized to an energy of 1) is assumed (it is provided on the Moodle),but several levels of noise will be considered. The channel can be assumed
perfectly known both at the transmitter and receiver.

- Provide a model of the parallel channels obtained with OFDM: establish the relationship between the OFDM transmission over the frequency selective multipath channel on one hand, and the AWGN parallel subchannels with different SNRs as used in the lecture about "Adaptive modulation" on the other hand.
- Establish the general procedure for maximizing the available bit rate by optimizing the allocated powers pk and the number of bits bk for a given channel impulse response (and hence frequency response) and based on the constraints described above. In order to simplify the procedure, it is assumed that bk is real and is not restricted to an
integer.
- Implement this optimization procedure for the particular realization of the channel impulse response provided to you for 3 different values Es/N0 = 0; 10 and 20 dB, and evaluate the gain (in terms of bit rate) with respect to uniform power allocation and/or uniform bit allocation.
## 3.1.1 Bonus: Power allocation only
In some situations, it may be too costly to implement adaptive modulation. In that case, the power allocation can still be optimized in order to improve the performance of the transmission. Assume that a fixed 4-QAM modulation is used on all subcarriers. The bit rate is now fixed, so the optimization has to be based on another criterion. Several criterions can be considered.
For this part, consider the minimization of the sum MSE (mean square error) over the subcarriers at the ouptut of the OFDM receiver, across all subcarriers.

- Based on the parallel channel model obtained above, provide the model of the mean square error at the output of each subcarrier of the OFDM receiver as a function of the powers pk.
- Establish the general procedure for minimizing the sum mean square error (sum MSE) by optimizing the allocated powers pk. Compare to the previous procedure and discuss the diferences.
### 3.2 Step 3: Channel estimation
The third and fourth steps build on the basic OFDM chain designed earlier and extend it to include two particular operations of a communication chain: the channel estimation, and the decoding of the error correcting code.
For channel estimation, it is assumed that a training sequence (also called preamble) is sent by the transmitter. The preamble considered here is made of two identical OFDM symbols in which the symbol Ik sent on subcarrier k (k-0; : : : ;N-1) is given by
Ik = (-1)^k: 
Hence the transmitted power is equal on all subcarriers.
In this part, the channel is assumed to be an 8-tap channel with 8 independent Rayleigh taps with uniform power delay profile. In all your simulations,and for a given Es=N0 the results should be averaged over a suficient number of realizations of the randomly generated channel.
- Choose and derive a channel estimation method for this training sequence.
- Implement the channel estimation in your OFDM chain by simulating the transmission of the training sequence and performing the computation of the channel estimation. Evaluate and plot the performance of your estimator (in terms of mean square error) as a function of Es/N0 ranging from 0 dB to 20 dB.
### 3.3 Step 4: Optimal Viterbi decoding
If the channel is not known at the transmitter, convolutional coding is usually used across the frequencies in order to counteract the possibility of deep fades on some of the subcarriers. For simplicity we assume a code of rate 1/2 working on a frame of Lf = 128 bits. The convolutional code is given by G(D) = [1 + D 1 + D + D^2]. The 256 coded bits are multiplexed on the 128 subcarriers modulated in 4-QAM, and forming one OFDM symbol. The receiver is either assuming perfect channel knowledge or using the channel estimation obtained in step 3. We consider Viterbi decoding, but the objective is to revisit the algorithm by taking into account the channel knowledge and the specific gain in each subcarrier.
- Establish a model for the transmission of the 256 coded bits, taking into account the channel frequency selectivity (remember that ideal OFDM transmission can be seen as independent parallel channels).
- Assuming that the channel is perfectly known at the receiver (decoder) side, derive the expression of the maximum likelihood sequence decoder.
- Adapt the Viterbi algorithm accordingly.
- Implement the Viterbi algorithm and show the performance improvement that can be obtained by correctly taking into account the knowledge of the channel (at the receiver). Provide a BER vs. Es=N0 curve for the two versions of the algorithm by averaging over many channel realizations. Compare the performance obtained with perfect channel knowledge and with the estimation obtained from your estimator implemented in step 3.
