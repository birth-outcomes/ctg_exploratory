# Exploratory analysis of the CTU-CHB Intrapartum Cardiotocography Database

**Aim:** Understand and explore how the fetal heart rate (FHR) and uterine contraction (UC) signals can be used in prediction of poor fetal outcomes. Based on methods used in the literature, this has included exploring short-time fourier transform (STFT), continuous wavelet transform (CWT) and convolutional neural nets (CNN).

## Dataset

**Amy's description of the dataset:**

There are 552 records each containing fetal heartrate (measured in bpm) and uterine contractions (measured in mmHg). These are provided four times a second, with the entire record being a maximum of 90 minutes long. For each record, there is metadata with data about the mother and fetus, including information relating to fetal outcome.

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

**Relevant links:**
* PhysioNet link to dataset - https://physionet.org/content/ctu-uhb-ctgdb/1.0.0/
* DOI linking to PhysioNet - https://doi.org/10.13026/C22013
* Paper describing the dataset - https://bmcpregnancychildbirth.biomedcentral.com/track/pdf/10.1186/1471-2393-14-16.pdf

**Citing the dataset:**
* When using this resource, please cite the original publication: Václav Chudáček, Jiří Spilka, Miroslav Burša, Petr Janků, Lukáš Hruban, Michal Huptych, Lenka Lhotská. Open access intrapartum CTG database. BMC Pregnancy and Childbirth 2014 14:16.
* Please include the standard citation for PhysioNet: (show more options) Goldberger, A., Amaral, L., Glass, L., Hausdorff, J., Ivanov, P. C., Mark, R., ... & Stanley, H. E. (2000). PhysioBank, PhysioToolkit, and PhysioNet: Components of a new research resource for complex physiologic signals. Circulation [Online]. 101 (23), pp. e215–e220.

**License:**
* Open Data Commons Attribution License v1.0 
* https://physionet.org/content/ctu-uhb-ctgdb/view-license/1.0.0/
* https://opendatacommons.org/licenses/by/index.html