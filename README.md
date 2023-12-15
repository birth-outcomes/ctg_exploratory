# Exploratory analysis of CTG data for classifying fetal outcomes during labour

This repository aims to understand and explore how the fetal heart rate (FHR) and uterine contraction (UC) signals can be used in prediction of poor fetal outcomes. Based on methods used in the literature, this has included exploring:
* Short-time fourier transform (STFT)
* Continuous wavelet transform (CWT)
* Convolutional neural nets (CNN)
* Feature extraction based on FIGO guidelines

We've used two sources of CTG data:
* The CTU-CHB Intrapartum Cardiotocography Database
* The training and test datasets provided in the FHRMA toolbox

---

## CTU-CHB Intrapartum Cardiotocography Database

### CTG data (with accompanying maternal information)

**Description of the dataset from PhysioNet:**

The database, from the Czech Technical University (CTU) in Prague and the University Hospital in Brno (UHB), contains 552 cardiotocography (CTG) recordings, which were carefully selected from 9164 recordings collected between 2010 and 2012 at UHB.

The CTG recordings start no more than 90 minutes before actual delivery, and each is at most 90 minutes long. Each CTG contains a fetal heart rate (FHR) time series and a uterine contraction (UC) signal, each sampled at 4 Hz.

The priority was to create as homogeneous a set as possible; thus only recordings fulfilling the following criteria were included:

* Singleton pregnancy
* Gestational age >36 weeks
* No a priori known developmental defects
* Duration of stage 2 of labor ≤ 30 minutes
* FHR signal quality (i.e. percentage of the recording during which FHR data were available) > 50% in each 30 minute window
* Available analysis of biochemical parameters of umbilical arterial blood sample (i.e. pH)
* Majority of vaginal deliveries (only 46 cesarean section (CS) deliveries included)

Additional parameters were collected for all recordings, and are available in the (text) .hea files of the records:

* Maternal data: age; parity; gravidity;
* Delivery data: type of delivery (vaginal; operative vaginal; CS); duration of delivery; meconium stained fluid; type of measurement (i.e. ultrasound or direct scalp electrode);
* Fetal data: sex; birth weight;
* Fetal outcome data: analysis of umbilical artery blood sample (i.e. pH; pCO2; pO2; base excess and computed BDecf); Apgar score; neonatology evaluation (i.e. need for O2; seizures; admission to NICU)
* Expert evaluation of the CTG data "Gold Standard" evaluation based on annotation of the signals by 9 expert obstetricians (following FIGO guidelines used in the Czech Republic) including variability/confidence for each signal (Note: these data are not yet available!)

**Description of expert evaluation as described in Hruban et al. 2015**

The CTGAnnotator was used to obtain annotation of the CTG recordings from nine expert-obstetricians. The CTGAnnotator presented the CTG trace in form of consecutive 30-minute windows together with basic clinical information. Each window was expected to be evaluated based on FIGO criteria by assigning it to one of the three classes (Normal/Suspicious/Pathological). All obstetricians working on delivery wards of six Obstetrics and Gynecology Departments of all the University Hospitals in the Czech Republic have been currently practicing delivery ward doctors with median experience of 15 years (minimum 10, maximum 33). Based on the data structure each recording was presented in four steps:
* 30 minutes long window beginning at maximum one hour before the end of the first stage of labor
* 30 minutes long window beginning at maximum 30 minutes before the end of the first stage of labor
* Full second stage of labor signal presented for evaluation if five minutes or more of CTG signal was available
* Evaluation of labor outcome – prediction of umbilical artery pH after delivery

File contains:
* rec_id - identification of records (corresponds to the physionet ID, values: [1001-1506],[2001,2046])
* expert_id - identification of clinicicians, values: [1,2,...,9]
* eval_step1-3 - annotation of step 1 to 3, values (normal=1, suspicious=2, pathological=3, uninterpretable=-1)
* eval_step4 - annotation of step 4, values (no hypoxia=1, mild hypoxia=2, severe hypoxia=3, uninterpretable=-1)

**Relevant links:**
* PhysioNet link to dataset - https://physionet.org/content/ctu-uhb-ctgdb/1.0.0/
* DOI linking to PhysioNet - https://doi.org/10.13026/C22013
* Paper describing the dataset - https://bmcpregnancychildbirth.biomedcentral.com/track/pdf/10.1186/1471-2393-14-16.pdf
* Link to file describing the .hea files - http://ctg.ciirc.cvut.cz/CTU_UHB_database/index.html
* Link to expert evaluation as described in Hruban et al. 2015 - http://people.ciirc.cvut.cz/~spilkjir/data.html

**Citation:**
Dataset:
* When using this resource, please cite the original publication: Václav Chudáček, Jiří Spilka, Miroslav Burša, Petr Janků, Lukáš Hruban, Michal Huptych, Lenka Lhotská. Open access intrapartum CTG database. BMC Pregnancy and Childbirth 2014 14:16.
* Please include the standard citation for PhysioNet: (show more options) Goldberger, A., Amaral, L., Glass, L., Hausdorff, J., Ivanov, P. C., Mark, R., ... & Stanley, H. E. (2000). PhysioBank, PhysioToolkit, and PhysioNet: Components of a new research resource for complex physiologic signals. Circulation [Online]. 101 (23), pp. e215–e220.

**License:**
For the dataset:
* Open Data Commons Attribution License v1.0 
* https://physionet.org/content/ctu-uhb-ctgdb/view-license/1.0.0/
* https://opendatacommons.org/licenses/by/index.html

### Expert annotation

Source: L. Hruban, J. Spilka, V. Chudáček, P. Janků, et al. Agreement on intrapartum cardiotocogram recordings between expert obstetricians In Journal of Evaluation in Clinical Practice, 21(4): 694-702, 2015.

The expert annotations are free to use for non-commercial purposes, given that any publication using the database refers to the publication Hruban et al. 2015.

---
## FHRMA (Fetal Heart Rate Morphological Analysis)

Source: https://github.com/utsb-fmm/FHRMA/tree/master

License: GPL-3.0

The dataset contains 155 FHR recordings in which a reference baseline, accelerations and decelerations have been annotated by expert consensus. 66 FHR recordings with a shared expert analysis have been included in a training dataset, and 90 other FHR recordings with a non-shared expert analysis have been included in an evaluation dataset. Researchers wishing to evaluate their automatic analysis method should submit their results for comparison with the expert consensus. The dataset also contains the results produced by 12 re-coded automatic analysis methods from the literature. The baseline, accelerations, decelerations, and over-shoots are not publicly shared for the recordings in the evaluation dataset to avoid any training on those data.

Main information are published in : [1] Boudet, S., Houzé de l’Aulnoit, A., Demailly, R., Delgranche, A., Peyrodie, L., Beuscart, R., Houzé de l’Aulnoit,D. - Fetal heart rate signal dataset for training morphological analysis methods and evaluating them against an expert consensus. Preprints pp. Submitted to data in brief,2019, DOI:10.20944/preprints201907.0039.v1

**Citation:**

The toolbox is related to several papers. Please cite those papers if you use any of the data or source code of this repository. [4] must be cited if you use the toolbox. [1] must be cited if you use the morphological analysis (baseline, Acceleration, deceleration) [3] must be cited if you use the morphological analysis dataset. [5] must be cited if you use the WMFB method (current best) for morphological analysis. [6] must be cited if you use the false signal detection, method, interface and/or dataset.
* [1] Houzé de l’Aulnoit, A., Boudet, S., Demailly, R., Delgranche, A., Peyrodie, L., Beuscart, R., Houzé de l’Aulnoit,D. - Automated fetal heart rate analysis for baseline determination and acceleration/deceleration detection: A comparison of 11 methods versus expert consensus. Biomedical Signal Processing and Control 49:113 -123,2019, DOI:10.1016/j.bspc.2018.10.002
* [2] Houzé de l'Aulnoit, Agathe, Boudet, Samuel, Demailly, Romain, Peyrodie, Laurent, Beuscart, Regis, Houzé de l'Aulnoit, Denis - Baseline fetal heart rate analysis: eleven automatic methods versus expert consensus. Engineering in Medicine and Biology Society (EMBC), 2016 IEEE 38th Annual International Conference of the pp. 3576--3581,2016, DOI:10.1109/EMBC.2016.7591501 Download on researchgate
* [3] Boudet, S., Houzé de l’Aulnoit, A., Demailly, R., Delgranche, A., Peyrodie, L., Beuscart, R., Houzé de l’Aulnoit,D. - Fetal heart rate signal dataset for training morphological analysis methods and evaluating them against an expert consensus. Preprints pp. Submitted to data in brief,2019, DOI:10.20944/preprints201907.0039.v1
* [4] Boudet, S., Houzé de l’Aulnoit, A., Demailly, R., Delgranche, A., Peyrodie, L., Beuscart, R., Houzé de l’Aulnoit,D. - A fetal heart rate morphological analysis toolbox for MATLAB. SoftwareX. 2020 Jan 1;11:100428. DOI:10.1016/j.softx.2020.100428
* [5] Boudet, S., Houzé de l’Aulnoit, A., Demailly, R., Peyrodie, L., Beuscart, R., Houzé de l’Aulnoit,D. - Fetal heart rate baseline computation with a weighted median filter. Computers in biology and medicine. 2019 Nov 1;114:103468. DOI:10.1016/j.compbiomed.2019.103468
* [6] Boudet, S., Houzé de l’Aulnoit, A., Demailly, R., Peyrodie, L., Houzé de l’Aulnoit,D. - Use of deep learning to detect the maternal heart rate and false signals on fetal heart rate recordings. Biosensors 2022; 12(9):691. DOI:10.3390/bios12090691