C This file is part of the ESP-r system.
C Copyright Energy Systems Research Unit, University of
C Strathclyde, Glasgow Scotland, 2001.

C ESP-r is free software.  You can redistribute it and/or
C modify it under the terms of the GNU General Public
C License as published by the Free Software Foundation 
C (version 2 orlater).

C ESP-r is distributed in the hope that it will be useful
C but WITHOUT ANY WARRANTY; without even the implied
C warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
C PURPOSE. See the GNU General Public License for more
C details.

C You should have received a copy of the GNU General Public
C License along with ESP-r. If not, write to the Free
C Software Foundation, Inc., 59 Temple Place, Suite 330,
C Boston, MA 02111-1307 USA.

C **********************************************************************
C TRSTYP of ESRUplt
C This file contains the following TRNSYS type components
C       TYPE1   Solar collector
C       TYPE6   STATIC ON-OFF BOILER
C       TYPE16  Solar radiation processor
C       TYPE32  Chilled water cooling coil.

C NOTE that type16 is not used in ESP as a plant component,
C but is called to evaluate solar radiation components that
C are required by TYPE1. Once these solar components can be
C calculated using existing ESP solar routines, TYPE16 will
C removed.

C ******************** TYPE1 ********************

cjh TYPE1 calls SUBROUTINE DATA, which is a dummy routine.
cjh Since forchk generates a lot of errors on these
cjh CALL DATA dummy statements, they might just as well be disabled.

      SUBROUTINE TYPE1(TIME,XIN,OUT,T,DTDT,PAR,INFO)
      INTEGER CMODE,EMODE,OMODE
      DIMENSION PAR(15),XIN(15),OUT(20),INFO(10)
      DIMENSION NPAR1(4),NPAR2(6),NINP1(4),NINP2(6)
      DIMENSION NX1(3),X(3),Y(2),WCON(2),ECON(2),ACON(2),BCON(2)
      DATA RDCONV/0.017453/,SQRT2/1.41421356/
      DATA NPAR1/11,10,8,10/NPAR2/1,2,4,2,4,4/,NINP1/5,5,5,4/,
     .   NINP2/5,5,5,6,5,8/
      DATA NX1/3*0/,NDELT/9/,EG/0.88/,SIGMA/5.67E-08/
      DATA WCON/1.,0.447/,ECON/3.6,0.1761/,ACON/0.,32./,BCON/1.,1.8/

      IU=0

C << confusion as to what TAUALF is. Compiler thinks it needs subscripts
C << but it might be a function.
C      TAUALF(THETA)=1.-B0*(1./AMAX1(0.5,COS(THETA*RDCONV))-1.)
C     .             - (1.-B0)*(AMAX1(60.,THETA)-60.)/30.
      TAUALF=1.-B0*(1./AMAX1(0.5,COS(THETA*RDCONV))-1.)
     .             - (1.-B0)*(AMAX1(60.,THETA)-60.)/30.

      IF(INFO(7).GT.-1) GO TO 5

C  FIRST CALL OF SIMULATION
      PI = 4.0 * ATAN(1.0)
      INFO(9)=0
      INFO(6)=3
      CMODE=INT(PAR(1)+0.1)
C
      NP=NPAR1(CMODE)
      NI=NINP1(CMODE)
C
      IF(CMODE.LE.2) OMODE=INT(PAR(NP)+0.1)
      IF(CMODE.EQ.3) OMODE=5
      IF(CMODE.EQ.4) OMODE=6
cea      IF(OMODE.LT.1) GO TO 1
C
      NP=NP+NPAR2(OMODE)
      NI=NI+NINP2(OMODE)
C
cea1     CALL TYPECK(1,INFO,NI,NP,0)
C
5     IF(INFO(1) .EQ. IU) GO TO 60
      IU=INFO(1)
C
C  SET PARAMETERS
      CMODE=INT(PAR(1)+0.1)
      IP=0
      IF(CMODE.EQ.3) IP=1
      NS=INT(PAR(IP+2)+0.1)
      XNS=FLOAT(NS)
      A=PAR(IP+3)
      CPC=PAR(IP+4)
C
      GO TO (10,20,30,40) ,CMODE
C  MODE 1
10    EMODE=INT(PAR(5)+0.1)
      GTEST=PAR(6)
      FRTAN=PAR(7)
      FRUL=PAR(8)
      EFFEC=PAR(9)
      CPF=PAR(10)
      IF(EFFEC.LE.0.) CPF=CPC
C  MODIFY TEST RESULTS TO BE BASED ON (TI-TA)/GT
      GO TO (16,17,18) ,EMODE
16    RATIO=1.
      GO TO 19
17    RATIO=1./(1.+FRUL/GTEST/CPC/2.)
      GO TO 19
18    RATIO=1./(1.+FRUL/GTEST/CPC)
19    FRTAN=RATIO*FRTAN
      FRUL=RATIO*FRUL
C
      FPUL=-GTEST*CPC*ALOG(1.-FRUL/GTEST/CPC)
      RTEST=GTEST*CPC*(1.-EXP(-FPUL/GTEST/CPC))
      GO TO 50
C  MODE 2
20    EMODE=INT(PAR(5)+0.1)
      LU1=INT(PAR(6)+0.1)
      DO 21 I=1,3
21    NX1(I)=INT(PAR(6+I)+0.1)
      GO TO 50
C  MODE 3
30    IU=INT(PAR(2)+0.1)
      FP=PAR(6)
      UBE=PAR(7)
      EP=PAR(8)
      OMODE=5
      GO TO 50
C  MODE 4
40    FP=PAR(5)
      UL=PAR(6)
      RHOR=PAR(7)
      THETAC=PAR(8)
      HFRACT=PAR(9)
      IAXIS=INT(PAR(10)+0.1)
      OMODE=6
      IF(INFO(7).GT.-1) GO TO 50
      SINTC=SIN(THETAC*RDCONV)
      SINSQ = SINTC*SINTC
      COSHAF = COS(THETAC*RDCONV)
      COSSQ = COSHAF*COSHAF
      COTSQ = COSSQ/SINSQ
      SINHF1 = SINTC + 1.
C   FIND REFLECTIVE LOSS. SEE RABL, 'OPTICAL AND THERMAL PROPERTIES OF
C  COMPOUND PARABOLIC CONCENTRATORS', SOLAR ENERGY JOURNAL, VOL 18,
C  NO. 6, PAGES 497-511.  AFRACT IS (REFLECTOR AREA)/(RECEIVER AREA)
C  AND ENI IS THE AVERAGE NUMBER OF INTERNAL REFLECTIONS.
      XBAR1 = SINHF1/COSHAF *  (-SINTC+SQRT(1.0+HFRACT*COTSQ))
      CR = 2.0*COSHAF*XBAR1 - XBAR1*XBAR1*SINTC/SINHF1 + SINTC - COSSQ
      AA = SQRT(SINHF1*SINHF1 + XBAR1*XBAR1)
      BB = SQRT2*SQRT(SINHF1)
      CC = SQRT(1.0 + XBAR1*XBAR1/SINHF1/SINHF1)
      AFRACT = SINHF1*ALOG((XBAR1+AA)/(COSHAF+BB)) + XBAR1*CC -
     .                  SQRT2*COSHAF/SQRT(SINHF1)
      ENI = 0.5*(AFRACT - (XBAR1*XBAR1-COSSQ)/SINHF1)
      RHOEFF = RHOR**ENI
      OUT(14)=CR
      OUT(15)=RHOEFF
C  OPTICAL PARAMETERS
50    IP=NPAR1(CMODE)
      IF(CMODE.LE.2) OMODE=INT(PAR(IP)+0.1)
      IF(OMODE.LT.1) GO TO 60
      GO TO (52,53,54,53,54,54) ,OMODE
52    B0=PAR(IP+1)
      GO TO 60
53    continue
cjh      LU2=INT(PAR(IP+1)+0.1)
cjh      NX2=INT(PAR(IP+2)+0.1)
      GO TO 60
54    ALF=PAR(IP+1)
      XNG=PAR(IP+2)
      NG=INT(XNG+0.1)
      RI=PAR(IP+3)
      XKL=PAR(IP+4)
      IF(OMODE.NE.6) GO TO 55
      RHOEFF=OUT(15)
      ALF=ALF*RHOEFF
55    IF(INFO(7).GT.-1) GO TO 60
C  COVER TRANSMITTANCE AT NORMAL INCIDENCE
      RHOD=-1.
      TALN=TALF(NG,0.0,XKL,RI,ALF,RHOD)
      OUT(18)=RHOD
      OUT(19)=TALN
C
C  INPUTS
60    TI=XIN(1)
      FLWC=XIN(2)
      IN=5
      IF(CMODE.EQ.4) IN=4
      IF(CMODE.GT.1) GO TO 61
      FLWF=XIN(3)
      IF(EFFEC.LE.0.) FLWF=FLWC
      TA=XIN(4)
      GT=XIN(5)
      GO TO 62
61    TA=XIN(3)
      GT=XIN(4)
      IF(CMODE.EQ.2 .OR. CMODE.EQ.3) WIND=XIN(5)
62    IF(OMODE.EQ.4) GO TO 63
      XKAT=1.
      IF(OMODE.LT.1) GO TO 100
      GH=XIN(IN+1)
      GD=XIN(IN+2)
      RHO=XIN(IN+3)
      THETA=XIN(IN+4)
      IF(OMODE.EQ.6) GO TO 64
      SLP=XIN(IN+5)
      GO TO 65
C
63    GDT=XIN(IN+1)
      THETA=XIN(IN+2)
      THETAZ=XIN(IN+3)
      SAZM=XIN(IN+4)
      SLP=XIN(IN+5)
      AZMTH=XIN(IN+6)
      GO TO 65
C
64    THETAZ=XIN(IN+5)
      SAZM=XIN(IN+6)
      SLP=XIN(IN+7)
      AZMTH=XIN(IN+8)
C
65    IF(INFO(7).GT.0) GO TO 100
C**DETERMINE INCIDENCE ANGLE MODIFIER, ONCE EACH TIMESTEP
      IF(GT .GT. 0. .AND. THETA .LT. 90.) GO TO 70
C
C  NO RADIATION
      XKAT=0.
      GO TO 100
C
C
70    IF(OMODE.EQ.4) GO TO 80
      IF(OMODE.EQ.6) GO TO 90
C
C  FLAT PLATES
C    USE RELATIONS OF BRANDEMUEHL FOR EFFECTIVE INCIDENCE ANGLES
C    FOR DIFFUSE
      EFFSKY=59.68-0.1388*SLP+0.001497*SLP*SLP
      EFFGND=90.-0.5788*SLP+0.002693*SLP*SLP
      COSSLP=COS(SLP*RDCONV)
      FSKY=(1.+COSSLP)/2.
      FGND=(1.-COSSLP)/2.
      GDSKY=FSKY*GD
      GDGND=RHO*FGND*GH
      IF(OMODE.EQ.5) GO TO 73
      GO TO (71,72,73) ,OMODE
C
C    USE CONSTANT FROM ASHRAE TESTS
C << what is TAUALF (function or array)?  >>
C71    XKATB=TAUALF(THETA)
C      XKATDS=TAUALF(EFFSKY)
C      XKATDG=TAUALF(EFFGND)
71    XKATB=TAUALF
      XKATDS=TAUALF
      XKATDG=TAUALF
      GO TO 75
C
C    USE DATA
72    continue
cjh 72CALL DATA(LU2,1,NX2,1,THETA,XKATB,INFO)
cjh   CALL DATA(LU2,1,NX2,1,EFFSKY,XKATDS,INFO)
cjh   CALL DATA(LU2,1,NX2,1,EFFGND,XKATDG,INFO)
      GO TO 75
C
C  USE COVER COVER PROPERTIES
73    RHOD=OUT(18)
      TALN=OUT(19)
      XKATDS=TALF(NG,EFFSKY,XKL,RI,ALF,RHOD)/TALN
      XKATDG=TALF(NG,EFFGND,XKL,RI,ALF,RHOD)/TALN
      XKATB=TALF(NG,THETA,XKL,RI,ALF,RHOD)/TALN
C
75    XKAT=(XKATB*(GT-GDSKY-GDGND)+XKATDS*GDSKY+XKATDG*GDGND)/GT
      GO TO 100
C
C  NON-OPTICALLY SYMMETRIC COLLECTORS, EVACUTED TUBES, CPC'S, ETC.
C
80    IF(THETAZ.LT.90.) GO TO 82
      XKAT=0.
      GO TO 100
C    BEAM
82    TANTT=SIN(THETAZ*RDCONV)*SIN(ABS(AZMTH-SAZM)*RDCONV)
     .   /COS(THETA*RDCONV)
cjh      THETAT=ATAN(TANTT)/RDCONV
      TANALF=TAN(THETAZ*RDCONV)*COS((AZMTH-SAZM)*RDCONV)
cjh      THETAL=ABS(ATAN(TANALF)/RDCONV-SLP)

C << Y parameter in next line should not be array. >> 
cjh   CALL DATA(LU2,1,NX2,2,THETAL,Y,INFO)
cjh Y(I) arbitrarily set to 0 in the next line to avoid 'not defined'
cjh since it's value comes from a dummy routine this is OK ??
      Y(1)=0.
      Y(2)=0.
      XKATB=Y(1)
C << Y parameter in next line should not be array. >> 
cjh   CALL DATA(LU2,1,NX2,2,THETAT,Y,INFO)
      XKATB=XKATB*Y(2)
      IF(OUT(20).GT.0.) GO TO 85
C  DETERMINE MODIFIER FOR DIFFUSE, ONCE DURING SIMULATION
      XKATD2=0.
      DDELT=PI/2./FLOAT(NDELT)
      DO 84 I=1,NDELT
      XKATD1=0.
      SAZM=FLOAT(I-1)*DDELT+DDELT/2.
      DO 83 J=1,NDELT
      THETA=FLOAT(J-1)*DDELT+DDELT/2.
      SINTT=SIN(THETA)
      COSTT=COS(THETA)
      TANTT=SINTT/COSTT
cjh      THETAT=ATAN(TANTT*SIN(SAZM))/RDCONV
cjh      THETAL=ATAN(TANTT*COS(SAZM))/RDCONV
C << Y parameter in next line should not be array. >> 
cjh   CALL DATA(LU2,1,NX2,2,THETAL,Y,INFO)
      XKATD=Y(1)
C << Y parameter in next line should not be array. >> 
cjh   CALL DATA(LU2,1,NX2,2,THETAT,Y,INFO)
      XKATD=XKATD*Y(2)
83    XKATD1=XKATD1+XKATD*COSTT*SINTT*DDELT
84    XKATD2=XKATD2+XKATD1*DDELT
      XKATD=4.*XKATD2/PI
      OUT(20)=XKATD
85    XKATD=OUT(20)
      XKAT=(XKATB*(GT-GDT)+XKATD*GDT)/GT
      GO TO 100
C  THEORETICAL CPC
C   USE EFFECTIVE INCIDENCE ANGLE FOR DIFFUSE FROM BRANDEMUEHL
90    EFFD=44.86-0.0716*THETAC+0.00512*THETAC*THETAC
     .   -0.00002798*THETAC*THETAC*THETAC
      COSSLP=COS(SLP*RDCONV)
      CR=OUT(14)
      GO TO (91,92) ,IAXIS
C  HORIZONTAL AXIS
91    FSKY=(1./CR+AMIN1(1./CR,COSSLP))/2.
      FGND=(AMAX1(1./CR,COSSLP)-COSSLP)/2.
      TANALF=TAN(THETAZ*RDCONV)*COS((AZMTH-SAZM)*RDCONV)
      THETAP=ABS(ATAN(TANALF)/RDCONV-SLP)
      GO TO 95
C  SLOPED AXIS
92    FSKY=(1.+COSSLP)/CR/2.
      FGND=(1.-COSSLP)/CR/2.
      TANTP=SIN(THETAZ*RDCONV)*SIN(ABS(AZMTH-SAZM)*RDCONV)
     .   /COS(THETA*RDCONV)
      THETAP=ATAN(TANTP)/RDCONV
C  CHECK FOR SUN WITHIN ACCEPTANCE
95    FB=0.
      IF(THETAP.LE.THETAC) FB=1.
      XKATB=TALF(NG,THETA,XKL,RI,ALF,RHOD)/TALN
      XKATB=XKATB*FB
      XKATD=TALF(NG,EFFD,XKL,RI,ALF,RHOD)/TALN
      GB=GT-GD*(1.+COSSLP)/2.-RHO*GH*(1.-COSSLP)/2.
      GDT=GD*FSKY+RHO*GH*FGND
      XKAT=(XKATB*GB+XKATD*GDT)/GT
C
C
C**THERMAL PERFORMANCE
100    IF(INFO(7).LE.0) OUT(17)=XKAT
      XKAT=OUT(17)
      GO TO (110,150,200,200) ,CMODE
C  MODE 1, STANDARD ASHRAE PERFORMANCE
110   IF(FLWC.GT.0. .AND. (FLWF.GT.0. .OR. EFFEC.LE.0.)) GO TO 120
C    NO FLOW
      QU=0.
      TO=GT*FRTAN*XKAT/FRUL+TA
      GO TO 300
C    PUMP ON
120   R1=XNS*FLWC*CPC/A*(1.-EXP(-FPUL*A/XNS/FLWC/CPC))/RTEST
      XK=R1*A*FRUL/FLWC/CPC/XNS
      R2=(1.-(1.-XK)**NS)/XNS/XK
      R3=1.
      IF(EFFEC.GT.0.) R3=1./(1.+(A*R1*R2*FRUL)*(1./EFFEC/
     .   AMIN1(FLWC*CPC,FLWF*CPF)-1./FLWC/CPC))
      RATIO=R1*R2*R3
      QU=RATIO*A*(FRTAN*XKAT*GT-FRUL*(TI-TA))
      TO=QU/FLWF/CPF+TI
      GO TO 300
C
C  PERFORMANCE MAP
150   X(1)=0.
      X(2)=GT
      X(3)=WIND
      IF(FLWC.GT.0. .AND. GT.GT.0.) GO TO 160
C    NO FLOW
C << Info parameter in next line should not be array. >> 
cjh   CALL DATA(LU1,3,NX1,1,X,FRTAN,INFO)
      NX1(1)=-NX1(1)
C << Info parameter in next line should not be array. >> 
cjh   CALL DATA(LU1,3,NX1,1,X,EFFL,INFO)
cjh EFFL arbitrarily set to 0 in the next line to avoid 'not defined'
cjh since it's value comes from a dummy routine this is OK ??
      EFFL=0.
      NX1(1)=-NX1(1)
      FRUL=(FRTAN-EFFL)/X(1)
      TO=FRTAN*XKAT*GT/FRUL+TA
      QU=0.
      GO TO 300
C    PUMP ON
160   TO=TI
      QU=0.
C << Info parameter in next line should not be array. >> 
cjh   CALL DATA(LU1,3,NX1,1,X,FRTAN,INFO)
      DO 170 N=1,NS
      TI=TO
      ICT=0
      QLAST=0.
165   ICT=ICT+1
      GO TO (166,167,168) ,EMODE
166   X(1)=(TI-TA)/GT
      GO TO 169
167   X(1)=((TI+TO)/2.-TA)/GT
      GO TO 169
168   X(1)=(TO-TA)/GT
C << Info parameter in next line should not be array. >> 
169   continue
cjh169CALL DATA(LU1,3,NX1,1,X,EFFN,INFO)
cjh EFFN arbitrarily set to 0 in the next line to avoid 'not defined'
cjh since it's value comes from a dummy routine this is OK ??
      EFFN=0.
      EFF=EFFN-FRTAN*(1.-XKAT)
      QONE=EFF*GT*A/XNS
      TO=QONE/FLWC/CPC+TI
      IF(EMODE.EQ.1 .OR. ICT.EQ.5) GO TO 170
      IF(ABS(QONE-QLAST)/AMAX1(1.,QONE+QLAST) .LT. 0.02) GO TO 170
      QLAST=QONE
      GO TO 165
170   QU=QU+QONE
      GO TO 300
C
C  THEORETICAL FLAT PLATE OR CPC
200   IF(CMODE.EQ.3) HWIND=5.7+3.8*WIND*WCON(IU)
      QU=0.
      TO=TI
      NTIME=1
      IF(FLWC.GT.0.) NTIME=NS
      DO 240 N=1,NTIME
      TI=TO
      ICT=0
210   ICT=ICT+1
      IF(INFO(7).EQ.-1 .AND. CMODE.EQ.3) GO TO 230
      IF(CMODE.EQ.3) UL=OUT(16)
      IF(FLWC.GT.0.) GO TO 220
C  NO FLOW
      QONE=0.
      TO=GT*TALN*XKAT/UL+TA
      IF(CMODE.EQ.4) GO TO 240
      TM=TO
      GO TO 230
C  PUMP ON
220   expvt=-FP*UL*A/XNS/FLWC/CPC

C Test for underflows.
      if(expvt.lt.-50.0) then 
         expv=0.0
      else
         expv=exp(expvt)
      endif
      FR=FLWC*CPC*XNS/A/UL*(1.-expv)
      QONE=A/XNS*FR*(GT*TALN*XKAT-UL*(TI-TA))
      TO=QONE/FLWC/CPC+TI
      IF(CMODE.EQ.4) GO TO 240
      TM=(TO+TI)/2.
 
230   IF(ICT.EQ.2) GO TO 240
C  USE KLEIN'S TOP LOSS CORRELATION
      TMC=(TM-ACON(IU))/BCON(IU)+273.15
      TAC=(TA-ACON(IU))/BCON(IU)+273.15
      IF (TMC.LE.TAC) TMC=TAC+1.0
      F=(1.0-0.04*HWIND+5.0E-04*HWIND*HWIND)*(1.0+0.091*XNG)
      C=365.9*(1.0-0.00883*SLP+0.0001298*SLP*SLP)
      STF1=C/TMC*((TMC-TAC)/(XNG+F))**0.33
      STF1=XNG/STF1+1.0/HWIND
      STF1=1.0/STF1
      STF2=1.0/(EP+0.05*XNG*(1.0-EP))+(2.*XNG+F-1.)/EG-XNG
      STF2=SIGMA*(TMC*TMC+TAC*TAC)*(TMC+TAC)/STF2
      UL=(STF1+STF2)*ECON(IU)+UBE
      OUT(16)=UL
      GO TO 210
 
240   QU=QU+QONE
 
C  OUTPUTS
300   OUT(1)=TO
      OUT(2)=FLWF
      IF(CMODE.GT.1) OUT(2)=FLWC
      OUT(3)=QU
      RETURN
      END

C ******************** TYPE6 ********************
 
      SUBROUTINE TYPE6(TIME,XIN,OUT,T,DTDT,PAR,INFO)
C####################################################################
C STATIC ON-OFF BOILER
C ref.:  "Boiler specification"                    IEA Annex 10
C####################################################################
C M.DACHELET DEC 1987
C####################################################################
C Copied from paper (IEA Annex 10 specifications) by Jan Hensen, 1991
C Due to lack of available resources, comments not yet included
C####################################################################
cjh   COMMON /SIM/TIME0,TIMEF,DELT
      DIMENSION XIN(5),PAR(18),OUT(11),INFO(10)
      REAL NTU,MW,MC,MW0,MC0,K1,K2,KB,KD,KE,KW
      INTEGER GAMMA
 
C FIRST CALL
 
cjh   IF(INFO(7).EQ.-1) THEN
cjh      INFO(6)=11
cjh      CALL TYPECK(1,INFO,5,16,0)
cjh   ENDIF
 
C INITIALISATION OF INPUTS AND PARAMETERS
 
      MC=PAR(1)
      CO2=PAR(2)
      AU0=PAR(3)
      K1=PAR(4)
      K2=PAR(5)
      YW=PAR(6)
      DYW=PAR(7)
      KW=PAR(8)
      MC0=PAR(9)
      MW0=PAR(10)
      CO20=PAR(11)
      C1=PAR(12)
      C2=PAR(13)
      CPW=PAR(14)
      CPC=PAR(15)
      PC =PAR(16)

      TWSU=XIN(1)
      MW=XIN(2)
      TAMB=XIN(3)
      TAQUA=XIN(4)
      GAMMA=INT(XIN(5)+0.1)
      TC=TAMB
cjh   IF(MW.LE.0.) CALL TYPECK(3,INFO,0,0,0)
 
C CHECK IF BOILER IS OFF
 
      IF((GAMMA.EQ.0).OR.(TWSU.GT.TAQUA)) THEN
         CW=MW*CPW
         TWEX=(TWSU-(TWSU*YW*(1.-KW)/CW)+(YW*TAMB/CW))/(1.+(YW*KW/CW))
         QU=CW*(TWEX-TWSU)
         QC=0.
         TETAON=0.
         TETASB=0.
         ETA=0.
         ETAON=0.
         EFF=0.
         AU=0.
         GOTO 20
      ENDIF
 
C GENERAL CALCULATIONS
 
      QB=MC*PC
      CPG=C1+C2/CO2
      CPG0=C1+C2/CO20
      CPA=CPG-CPC
      CG=MC*CPG
      CG0=MC0*CPG0
      CW=MW*CPW
      CW0=MW0*CPW
      AU=AU0/(1.+K1*(CG0-CG)/CG+K2*(CW0-CW)/CW)
      NTU=AU/CG
      OMEGA=CG/CW
      UM0=1.-OMEGA
      EFF=(1.-EXP(-NTU*UM0))/(1.-OMEGA*EXP(-NTU*UM0))
      KB=(CPG*TWSU-(CPA*TAMB+CPC*TC))/PC
      TWEX=TAQUA
      QU=CW*(TWEX-TWSU)

      TAV=KW*TWEX+(1.-KW)*TWSU
      KD=(DYW*(TAV-TAMB))/QB
      KE=(YW*(TAV-TAMB))/QB
      ETAON=EFF*(1.-KB)-KD-KE
      QUMAX=QB*ETAON
      TETAON=((QU/QB)+KE)/(EFF*(1.-KB)-KD)
      TETASB=KE/(EFF*(1.-KB)-KD)

      IF(QU.LE.QUMAX) GOTO 30
 
C CALCULATION IN CASE OF FULL LOAD
 
      CC=CW+((YW+DYW)*KW)
      CD=((CW*TWSU)+(QB*EFF*(1.-KB))-((YW+DYW)*(((1.-KW)*TWSU)-TAMB)))
      TWEX=CD/CC
      QU=CW*(TWEX-TWSU)
      TETAON=1.
      ETAON=QU/QB
 
   30 CONTINUE
 
      QC=QB*TETAON
      ETA=QU/QC
 
C OUTPUTS AND END
 
   20 OUT(1)=TWEX
      OUT(2)=MW
      OUT(3)=QU
      OUT(4)=QC
      OUT(5)=QC/PC
      OUT(6)=TETAON
      OUT(7)=TETASB
      OUT(8)=ETA
      OUT(9)=ETAON
      OUT(10)=EFF
      OUT(11)=AU
 
      RETURN
      END

C ******************** TYPE16 ********************
cea       SUBROUTINE TYPE16(TIME,XIN,OUT,DUM1,DUM2,PAR,INFO)
       SUBROUTINE TYPE16(TIME,XIN,OUT,TIME0,TFINAL,DELT,PAR,INFO,luw)
       DIMENSION XIN(15),OUT(20),PAR(7),INFO(10)
C    THIS ROUTINE FINDS THE POSITION OF THE SUN IN THE SKY AND
C  ESTIMATES THE RADIATION INCIDENT ON UP TO SIX SURFACES OF
C  ANY ORIENTATION.
Cea       COMMON /SIM/ TIME0,TFINAL,DELT
       COMMON /STORE/ NSTORE,IAV,S(5000)
cea       COMMON /LUNITS/ LUR,LUW,IFORM
       DATA RDCONV/0.0174533/,DGCONV/57.2958/
C    STATEMENT FUNCTIONS TO CALCULATE SOLAR TIME AND HOUR
C  ANGLES. THE EQUATION OF TIME IS FROM D.L. SIEBERS, TECH.
C  REPORT  ME-HTL-75-2, PURDUE UNIVERSITY, LAFAYETTE, INDIANA
       PI = 4.0 * ATAN(1.0)
       IU=0
 
       IF (INFO(1) .EQ. IU) GO TO 10
       IU = INFO(1)
       MODE = INT(PAR(1) + .2)
       ITRK = INT(PAR(2) + .2)
       DAY1 = PAR(3)
       ALAT = PAR(4)*RDCONV
       SC = PAR(5)
       SHFT = PAR(6)
       NP = 6
       IE=1
       IF(INFO(4).GT.NP) IE = SIGN(1,int(PAR(NP+1)))
       IF(IE .EQ. -1) SHFT = 0.
       ALAT = SIGN(AMAX1(ABS(ALAT),1.E-06),ALAT)
       SINLAT = SIN(ALAT)
       COSLAT = COS(ALAT)
       TANLAT = SINLAT/COSLAT
       ID = INFO(10)
       NRAD = 1
       IF (MODE .GT. 3) NRAD = 2
       IF (INFO(7) .GT. -1) GO TO 10
cea       IF (MODE .LT. 1 .OR. MODE .GT. 5) CALL TYPECK(4,INFO,0,0,0)
cea       IF (ITRK .LT. 1 .OR. ITRK .GT. 4) CALL TYPECK(4,INFO,0,0,0)
       NS = MIN0((INFO(3)-NRAD-3)/2,4)
       IF (NS .LT. 0) NS = 0
       NI = NRAD + 3 + NS*2
       IF (INFO(4) .EQ. NP+1) NP = NP+1
       INFO(10) = 6
cea       CALL TYPECK(1,INFO,NI,NP,0)
       INFO(6) = 5 + MIN0(NS,1)*5 + MAX0(NS-1,0)*3
       ID = INFO(10)
       S(ID+5) = 0.
C   STORE INITIAL RADIATION DATA
       DDELT = XIN(NRAD+2) - XIN(NRAD+1)
       S(ID) = TIME0 + DDELT
       S(ID+1) = XIN(1)
       S(ID+2) = XIN(1)
       S(ID+3) = XIN(2)
       S(ID+4) = XIN(2)
       PI2365 = PI*2./365.242
       HDELT = DELT/2.
       CDELT = DELT*0.01
 
C   CALCULATE DECLINATION AND OTHER DAY DEPENDENT QUANTITIES.
10    DAY = DAY1 + (AINT(TIME/24.) - AINT(TIME0/24.))
       DECL = 0.40928*SIN((284.+DAY)*PI2365)
       SINDEC = SIN(DECL)
       COSDEC = COS(DECL)
       TANDEC = SINDEC/COSDEC
       WS = ACOS(-TANDEC*TANLAT)
       CC = COSLAT*COSDEC
       SS = SINLAT*SINDEC
       ECC = 1. + 0.033*COS(DAY*PI2365)
       ET1 = EOT((DAY-1.)*PI2365)
C   ET IS THE TIME SHIFT DUE TO THE ECCENTRICITY OF THE EARTHS ORBIT
15     ET = 0.
       IF (IE.GE.0) ET = ET1
 
C   FIND HOUR ANGLES FOR START AND END OF TIMESTEP. THE PORTION
C  OF THE TIMESTEP DURING WHICH THE SUN IS DOWN IS IGNORED.
       W1 = ANGLE(TIME-DELT,et,shft,rdconv)
       W2 = ANGLE(TIME,et,shft,rdconv)
       IF (W2 .LE. -WS .OR. W1 .GE. WS) GO TO 260
       W1 = AMAX1(W1,-WS)
       W2 = AMIN1(W2,WS)
       IF (ABS(W2-W1) .LT. CDELT) GO TO 260
       W  = (W1+W2)*0.5
       COSHR = COS(W)
       SINHR = SIN(W)
C   CHECK WHETHER NEW DATA CARD READ IN
       DDELT = XIN(NRAD+2) - XIN(NRAD+1)
       DTIME2 = S(ID)
       DTIME1 = DTIME2 - DDELT
       IF(TIME .LT. DTIME2+0.0001) GO TO 20
       DTIME1 = XIN(NRAD+1)
       DTIME2 = XIN(NRAD+2)
       S(ID) = DTIME2
       S(ID+1) = S(ID+2)
       S(ID+3) = S(ID+4)
       S(ID+2) = XIN(1)
       S(ID+4) = XIN(2)
C   SET DATA VARIABLES SO THAT (START OF DATA INTERVAL) .LE. (START
C   OF TIMESTEP) AND (END OF DATA INTERVAL) .GE. (END OF TIMESTEP)
20     IF ((TIME-DELT) .LT. DTIME1-0.0001) GO TO 24
       XIN1 = S(ID+2)
       XIN2 = S(ID+4)
       GO TO 28
24     DTIME1 = DTIME1 - DDELT
       XIN1 = S(ID+2) + S(ID+1)
       XIN2 = S(ID+4) + S(ID+3)
C    FIND HOUR ANGLES FOR START AND END OF DATA
28     WD1 = ANGLE(DTIME1,et,shft,rdconv)
       WD2 = ANGLE(DTIME2,et,shft,rdconv)
       WD1 = AMAX1(WD1,-WS)
       WD2 = AMIN1(WD2,WS)
C    CALCULATE EXTRATERRESTRIAL RADIATION FOR TIMESTEP AND THE RATIO
C   OF EXTRATERRESTRIAL FOR TIMESTEP TO EXTRATERRESTRIAL OVER PERIOD OF
C   DATA. RADIATION ON THE HORIZONTAL IS INTERPOLATED FROM DATA USING
C   THE CURVE FOR EXTRATERRESTRIAL RADIATION.
       HX1 = CC*(SIN(W2)-SIN(W1)) + SS*(W2-W1)
       HX2 = CC*(SIN(WD2)-SIN(WD1)) + SS*(WD2-WD1)
       HEXTRA = SC*ECC*HX1/(W2-W1)
       IF (HEXTRA .LT. 1.0E-6) THEN
         HEXTRA = 0.
         GOTO 260
       END IF
       HRATIO = HX1/HX2
 
C   FIND POSITION OF THE SUN
       SAZM = 0.
       COSZEN = CC*COSHR + SS
       COSZEN = SIGN(AMAX1(ABS(COSZEN),1.E-06),COSZEN)
       ZENITH = ACOS(COSZEN)
       SINZEN = SIN(ZENITH)
       TANZEN = SINZEN/COSZEN
       IF (ABS(SINZEN) .LT. 1E-06) GO TO 90
       SINAZM = COSDEC*SINHR/SINZEN
      SINAZM=SIGN(AMIN1(ABS(SINAZM),1.),SINAZM)
       SAZM = ASIN(SINAZM)
C  DETERMINE IF THE ABSOLUTE VALUE OF THE SOLAR AZIMUTH
C  IS GREATER THAN 90 DEGREES BY COMPARING THE HOUR
C  ANGLE WITH THE HOUR ANGLE AT WHICH THE SOLAR AZIMUTH IS
C  +/- 90 DEGREES
       CWEW = TANDEC/TANLAT
       CWEW = SIGN(AMIN1(ABS(CWEW),1.),CWEW)
       WEW = PI
       IF(ALAT*(DECL-ALAT) .LE. 0.0) WEW = ACOS(CWEW)
       IF((ABS(W)-ABS(WEW))*ALAT*(DECL-ALAT) .LE. 0.)
     .        SAZM = SIGN(PI,SAZM) - SAZM
C   DON'T ALLOW THE ABSOLUTE VALUE OF THE SOLAR AZIMUTH
C   TO BE GREATER THAN 180 DEGREES.
       IF(ABS(SAZM) .GT. PI) SAZM = SAZM - SIGN((2.*PI),SAZM)
 
C   FIND RATE OF BEAM,DIFFUSE AND TOTAL RADIATION ON HORIZONTAL SURFACE.
90     HRATIO = HRATIO/DELT
       GO TO (110,120,130,140,150), MODE
C    USE LIU AND JORDAN CORRELATION FOR BEAM AND DIFFUSE.
110    HHOR = XIN1*HRATIO
       XKT = AMIN1(HHOR/HEXTRA,0.75)
       HD = HHOR*(1.0045 + ((2.6313*XKT - 3.5227)*XKT +0.04349)*XKT)
       IF (HD .LT. 0.) HD = 0.
       IF (HD .GT. HHOR) HD = HHOR
       HB = HHOR - HD
       GO TO 200
C    USE BOES CORRELATION FOR DIRECT NORMAL RADIATION
120    HHOR = XIN1*HRATIO
       XKT = HHOR/HEXTRA
       HDN = (1.3304 * XKT - 0.3843) * SC
       IF (HDN .LT. 0.0) HDN = 0.0
       IF (HDN .GT. 0.739 * SC) HDN = 0.739 * SC
       HB = AMIN1(HDN*COSZEN,HHOR)
       HD = HHOR - HB
       GO TO 200
C   USE ERBS CORRELATION FOR BEAM AND DIFFUSE
130    HHOR = XIN1*HRATIO
       XKT = HHOR/HEXTRA
       IF(XKT .GT. 0.22) GO TO 132
       HD = HHOR*(1.0 - 0.09*XKT)
       GO TO 136
132    IF(XKT .GT. 0.80) GO TO 134
       HD = HHOR*(0.9511 - 0.1604*XKT + 4.388*XKT*XKT
     .       - 16.638*(XKT**3) + 12.336*(XKT**4))
       GO TO 136
134    HD = 0.165*HHOR
136    HB = HHOR - HD
       GO TO 200
C    INPUTS ARE BEAM AND DIFFUSE ON HORIZONTAL
140    HB = XIN1*HRATIO
       HD = XIN2*HRATIO
       HHOR = HB + HD
       GO TO 200
C    INPUTS ARE TOTAL (HORIZONTAL) AND DIRECT NORMAL
150    HHOR = XIN1*HRATIO
       HDN = XIN2*HRATIO
       HB = HDN*COSZEN
       HD = AMAX1(HHOR-HB,0.)
C   CHECK FOR BEAM RADIATION GREATER THAN EXTRATERRESTRIAL RADIATION
200   IF(HB .LE. HEXTRA) GO TO 220
       HB = HEXTRA
       IF((TIME-HDELT) .LT. TIME0) GO TO 220
       S(ID+5) = S(ID+5) + 1.
       IF (S(ID+5) .GT. 12.) GO TO 220
cea    WRITE (LUW,202) INFO(1),INFO(2),TIME
cea202    FORMAT(//2X,24H***** WARNING ***** UNIT,I3,5H TYPE,I3/4X,
cea     .    49HBEAM RADIATION EXCEEDS EXTRATERRESTRIAL AT TIME =,F10.4/
cea     .    4X,31HEXTRATERRESTRIAL RADIATION USED)
 
C  SET OUTPUTS
220    OUT(1) = HEXTRA
       OUT(2) = ZENITH*DGCONV
       OUT(3) = SAZM*DGCONV
       OUT(4) = HHOR
       OUT(5) = HD
C   CALCULATE BEAM RADIATION, TOTAL RADIATION AND INCIDENCE ANGLE
C  FOR EACH SLOPE.
       RHO = XIN(NRAD+3)
       NS = MIN0((INFO(3)-NRAD-3)/2,6)
       IF (NS .LE. 0) RETURN
       IP = NRAD + 4
       JP = 6
       DO 240 IS = 1,NS
       AXSLP = XIN(IP)*RDCONV
       AXAZM = XIN(IP+1)*RDCONV
       IP = IP + 2
       SINASL = SIN(AXSLP)
       COSASL = COS(AXSLP)
       COSASL = SIGN(AMAX1(ABS(COSASL),1.E-06),COSASL)
       TANASL = SINASL/COSASL
       ALF = SAZM - AXAZM
       ALF = SIGN(AMAX1(ABS(ALF),1.E-06),ALF)
C  KEEP THE DIFFERENCE OF SOLAR AZIMUTH AND AXIS AZIMUTH
C  BETWEEN 180 AND -180 DEGREES
       IF(ABS(ALF).GT.PI) ALF = ALF - SIGN((2.*PI),ALF)
       COSTTP = COSASL*COSZEN + SINASL*SINZEN*COS(ALF)
       COSTTP = SIGN(AMAX1(ABS(COSTTP),1.E-06),COSTTP)
       GO TO (221,223,222,225) ,ITRK
C   FIXED SURFACE
221    SLOPE = AXSLP
       AZM = AXAZM
       GO TO 227
C   SINGLE-AXIS TRACKER
222    IF(ABS(AMOD(AXSLP,180.)).GT.0.1) GO TO 223
C   HORIZONTAL AXIS
       IF(ALF.LT.0.) AZM = AXAZM - PI/2.
       IF(ALF.GT.0.) AZM = AXAZM + PI/2.
       TANSLP = TANZEN*COS(SAZM - AZM)
       SLOPE = ATAN(TANSLP)
       IF(SLOPE.LT.0.) SLOPE = PI + SLOPE
       GO TO 227
223    IF(ABS(AMOD(AXSLP,90.)).GT.0.1 .AND. ITRK.NE.2) GO TO 224
C   VERTICAL AXIS
       SLOPE = AXSLP
       AZM = SAZM
       GO TO 227
C   SLOPED AXIS
224    TANGAM = SINZEN*SIN(ALF)/SINASL/COSTTP
       GAM = ATAN(TANGAM)
       IF(GAM.LT.0. .AND. ALF.GT.0.) GAM = PI + GAM
       IF(GAM.GT.0. .AND. ALF.LT.0.) GAM = GAM - PI
       TANSLP = TANASL/COS(GAM)
       SLOPE = ATAN(TANSLP)
       IF(SLOPE.LT.0.) SLOPE = PI + SLOPE
       AZM = GAM + AXAZM
       IF(ABS(AZM).GT.PI) AZM = AZM - SIGN((2.*PI),AZM)
       GO TO 227
C   TWO-AXIS TRACKER
225    AZM = SAZM
       SLOPE = ZENITH
 
227    COSSLP  =  COS(SLOPE)
       COSTT = COSSLP*COSZEN + SIN(SLOPE)*SINZEN*COS(SAZM - AZM)
       THETA = ACOS(COSTT)*DGCONV
       SLOPE = SLOPE*DGCONV
       RB = AMAX1(COSTT,0.)/COSZEN
       HBEAM = HB*RB
       HDIFF = HD*(1.+ COSSLP)*0.5 + HHOR*RHO*(1.-COSSLP)*0.5
C    OUTPUT TOTAL (FLAT SURFACE) RADIATION, BEAM RADIATION,
C   DIFFUSE RADIATION, INCIDENCE ANGLE, AND SLOPE FOR FIRST SURFACE.
       IF (IS .GT. 1) GO TO 230
       OUT(JP) = HBEAM + HDIFF
       OUT(JP+1) = HBEAM
       OUT(JP+2) = HDIFF
       OUT(JP+3) = THETA
       OUT(JP+4) = SLOPE
C    OUT(20) SET TO W
       OUT(20) = W*DGCONV
       JP = JP + 5
       GO TO 240
C    OUTPUT TOTAL RADIATION, INCIDENT BEAM RADIATION, AND
C     INCIDENCE ANGLE FOR REMAINING SURFACES
230    OUT(JP) = HBEAM + HDIFF
       OUT(JP+1) = HBEAM
       OUT(JP+2) = THETA
       JP = JP + 3
240    CONTINUE
       GO TO 300
 
C  NO RADIATION
260    OUT(1) = 0.
       OUT(2) = 99.
       DO 270 I = 3,20
270    OUT(I) = 0.
C   SET DATA STORAGE VARIABLES.
       S(ID) = XIN(NRAD+1)
       S(ID+2) = 0.
       S(ID+4) = 0.
 
C   PRINT COUNT OF TIMES BEAM RADIATION GREATER THAN EXTRATERRESTRIAL
300    IF (TIME .LT. TFINAL-HDELT) RETURN
       NERR = INT(S(ID+5)+.5)
       IF (NERR .EQ. 0) RETURN
cea    WRITE(LUW,312) INFO(1),INFO(2),NERR
cea312    FORMAT(//2X,24H***** WARNING ***** UNIT,I3,5H TYPE,I3/4X,
cea  .   47HBEAM RADIATION EXCEEDED EXTRATERRESTRIAL DURING,I7,
cea  .   10H TIMESTEPS)
       RETURN
      END

C ******************** TYPE32 ********************
C Cooling coil.
C Copied from TRNSYS program by Essam Aasem  1992.
 
       SUBROUTINE TYPE32(TIME,XIN,OUT,T,DTDT,PAR,INFO)
C   THIS SUBROUTINE CALCULATES THE TOTAL HEAT TRANSFER (SENSIBLE
C   AND LATENT) FOR A CHILLED WATER COIL GIVEN INLET AIR AND WATER
C   CONDITIONS.  THE PROCEDURE USED IS DOCUMENTED IN
C     PROCEDURES FOR SIMULATING THE PERFORMANCE OF COMPONENTS
C     AND SYSTEMS FOR ENERGY CALCULATIONS,  THIRD EDITION,
C     EDITED BY W.F. STOECKER, 1975
 
C   CFM - AIR FLOW RATE IN STANDARD CUBIC FEET PER MINUTE
C   GPM - WATER FLOW RATE IN GALLONS PER MINUTE
C   EDB - ENTERINDG AIR DRY BULB TEMPERATURE IN F
C   EWB - ENTERING AIR WET BULB TEMPERATURE IN F
C   LDB - LEAVING AIR DRY BULB TEMPERATURE IN F
C   LWB - LEAVING AIR WET BULB TEMPERATURE IN F
C   EWT - ENTERING WATER TEMPERATURE
C   LWT - LEAVING WATER TEMPERATURE
C   QTW - RATE OF TOTAL HEAT TRANSFER IN BTU/HR
C   FA  - FACE AREA OF COIL IN FT2
C   NR  - NUMBER OF ROWS OF COIL
C   NC  - NUMBER OF COIL CIRCUITS
C
       REAL LWT,LDB,LWB,LWT1,LWT2,NROW,NCOIL,LMTD
       DIMENSION XIN(6),OUT(10),PAR(6),INFO(10)
       DIMENSION A1(6),B1(4),B(6),C(9),P(4)
       DATA A1/-7.90298,5.02808,-1.3816E-7,11.344,8.1328E-3,-3.349149/
       DATA B1/-9.09718,-3.56654,0.876793,0.0060273/
       DATA B/2.2074304,0.14178455E04,0.33925943E01,-0.55238537,
     1   -0.11071271E8,-0.39288579E09/
       DATA C/1.0007596,0.042652727,-0.22742528E-02,0.16232278E-02,
     1   0.41384645E-04,-0.24565063E-04,-0.24092761E-6,
     2   -0.11066765E-08,0.54302870E-10/
cea      INFO(6) = 8
cea       INFO(9) = 0
cea       IF(INFO(7).NE.-1) GO TO 3
cea       CALL TYPECK(1,INFO,5,5,0)
C  PARAMETERS
3     IUNITS=INT(PAR(1)+0.1)
      NROW=INT(PAR(2)+0.1)
      NCOIL=INT(PAR(3)+0.1)
      FA=PAR(4)
      DIA=PAR(5)
      RHO=62.4
C  INPUTS
      EDB = XIN(1)
      EWB = XIN(2)
      FLOWA = XIN(3)
      EWT = XIN(4)
      FLOW = XIN(5)
 
      IF(FLOWA.GT.1.E-06 .AND. FLOW.GT.1.E-06) GO TO 4
      OUT(1)=EDB
      OUT(2)=EWB
      OUT(3)=FLOWA
      OUT(4)=EWT
      OUT(5)=FLOW
      OUT(6)=0.
      OUT(7)=0.
      OUT(8)=0.
      RETURN
 
4      IF(IUNITS.EQ.2) GO TO 5
       EDB=EDB*1.8+32.
       EWB=EWB*1.8+32.
       EWT=EWT*1.8+32.
       FLOWA=FLOWA*2.2046
       FLOW=FLOW*2.2046
       FA=FA/.0929
       DIA=DIA/.3048
    5  GPM=FLOW/8.0208/RHO
       CFM=FLOWA*(EDB+459.69)/2381.1
       DT = .001
       PB = 29.921
       FPS=0.00276*GPM/DIA/DIA/NCOIL
C.   THE ABOVE EQN IS FROM PAGE 25 OF THE CARRIER DATA FOR 28SW COILS
       FPM=CFM/FA
       FPS=AMAX1(1.,AMIN1(FPS,8.))
       FPM=AMAX1(200.,AMIN1(FPM,800.))
       BRCW=B(1)+B(2)/FPM+B(3)/FPS+B(4)/FPS**2+B(5)/FPM**3+B(6)/
     . (FPS**2*FPM**4)
       BRCW=1./BRCW*1000.
 
 
       ITER=0
       ASSIGN 40 TO IKP
       DB=EDB
       WB=EWB
       GO TO 500
   40  EDB=DB
       EWB=WB
       HE=H
       EDP=DP
       PW=EDP-EWT
       BW=EDB-EWT
       PW=AMAX1(0.,AMIN1(PW,30.))
       BW=AMAX1(10.,AMIN1(PW,60.))
       WSF=C(1)+C(2)*PW+C(3)*PW*BW+C(4)*PW**2+C(5)*PW*BW**2+C(6)*BW*
     . PW**2+C(7)*BW**3*PW+C(8)*BW**3*PW**2+C(9)*BW**3*PW**3
       LWT1=EWT+5.
       LWT=LWT1
       ASSIGN 100 TO IJP
       GO TO 300
  100  F1=FF
       ASSIGN 200 TO IJP
       LWT2 = LWT1 + 2.
       LWT = LWT2
       GO TO 300
  200  F2=FF
       LWT = LWT2-F2/(F2-F1)*(LWT2-LWT1)
       IF(ABS(LWT2-LWT).LT.DT) GO TO 900
       ITER = ITER + 1
       IF(ITER.GT.25) GO TO 900
       LWT1=LWT2
       F1=F2
       LWT2=LWT
  300  QTW = 500.*GPM*(LWT-EWT)
       D1=EDB-LWT
       IF(D1.GT.0.0) GO TO 305
       D1=.11
       EDB = LWT + .11
  305  HL=HE-QTW/4.5/CFM
       H=HL
       ASSIGN 310 TO IMP
       GO TO 700
  310  LWB=WBF
       ASSIGN 320 TO INP
       WB=LWB
       RH1=0.95
       GO TO 800
  320  LDB=DBWBRH
       D2=LDB-EWT
       IF(D2.GT.0.0) GO TO 350
       D2 = .10
       LDB = EWT + 0.10
  350  LMTD=(D1-D2)/ALOG(D1/D2)
       QTC=BRCW*NROW*FA*WSF*LMTD
       FF=QTW-QTC
       GO TO IJP
 
C   CALCULATE VAPOR PRESSURE (PV), HUMIDITY RATIO (W), ENTHALPY (H),
C   VOLUME (V), AND DEW POINT (DP) WHEN THE DRY BULB TEMPERATURE (DB)
C   WET BULB TEMPERATURE (WB), AND BAROMETRIC PRESSURE (PB) ARE GIVEN
  500  ASSIGN 510 TO ILP
       X=WB
       GO TO 600
  510  PVP=PVSF
       IF(DB-WB)504,504,505
  505  WSTAR = 0.622*PVP/(PB-PVP)
       IF(WB-32.0)501,501,502
  501  PV = PVP-5.70E-04*PB*(DB-WB)/1.8
       GO TO 503
  504  PV=PVP
       GO TO 503
  502  CDB=(DB-32.)/1.8
       CWB=(WB-32.)/1.8
       HH=597.31+0.4409*CDB-CWB
       CH=0.2402+0.4409*WSTAR
       EX=(WSTAR-CH*(CDB-CWB)/HH)/0.622
       PV=PB*EX/(1.+EX)
  503  W=0.622*PV/(PB-PV)
       V=0.754*(DB+459.7)*(1.+7000.*W/4360.)/PB
       H=0.24*DB+(1061.+0.444*DB)*W
       Y=ALOG(PV)
       IF(PV.GT.0.1836) GO TO 506
       DPF=71.98+24.873*Y+0.8927*Y*Y
       GO TO  507
  506  DPF=79.047+30.579*Y+1.8893*Y*Y
  507  DP=DPF
       ASSIGN 520 TO ILP
       X=DB
       GO TO 600
  520  RH=PV/PVSF
       GO TO IKP
 
C   CALCULATE VAPOR PRESSURE (PVSF) OVER LIQUID WATER WHEN THE
C   TEMPERATURE (X) IS GIVEN.
  600  T=(X+459.688)/1.8
       IF(T.LT.273.16) GO TO 603
       Z=373.16/T
       P(1)=A1(1)*(Z-1.)
       P(2)=A1(2)*ALOG10(Z)
       Z1=A1(4)*(1.-1./Z)
       P(3)=A1(3)*(10**Z1-1.)
       Z1=A1(6)*(Z-1.)
       P(4)=A1(5)*(10**Z1-1.)
       GO TO 604
  603  Z=273.16/T
       P(1)=B1(1)*(Z-1.)
       P(2)=B1(2)*ALOG10(Z)
       P(3)=B1(3)*(1.-1./Z)
       P(4)=ALOG10(B1(4))
  604  SUM=0.
       DO 605 I=1,4
  605  SUM=SUM+P(I)
       PVSF=29.921*10**SUM
       GO TO ILP
 
C   CALCULATE WET BULB TEMPERATURE (WBF) WHEN GIVEN ENTHALPY (H)
C   AND BAROMETRIC PRESSURE (PB)
  700  IF(ABS(PB-29.92).GT.0.1) GO TO 702
       Y = ALOG(H)
       IF(H.GT.11.758) GO TO 703
       WBF = 0.6041+3.4841*Y+1.3601*Y*Y+0.97307*Y*Y*Y
       GO TO 704
  703  WBF = 30.9185-39.68200*Y+20.5841*Y*Y-1.758*Y*Y*Y
       GO TO 704
  702  WB1=150.
       X=WB1
       ASSIGN 720 TO ILP
       GO TO  600
  720  PV1=PVSF
       W1=0.622*PV1/(PB-PV1)
       X1=0.24*WB1+(1061.+0.444*WB1)*W1
       Y1=H-X1
  709  WB2=WB1-1.
       X=WB2
       ASSIGN 730 TO ILP
       GO TO 600
  730  PV2=PVSF
       W2=0.622*PV2/(PB-PV2)
       X2=0.24*WB2+(1061.+0.444*WB2)*W2
       Y2=H-X2
       IF(Y1*Y2) 706,707,708
  708  WB1=WB2
       Y1=Y2
       GO TO 709
  707  IF(Y1) 710,711,710
  711  WBF=WB1
       GO TO 704
  710  WBF=WB2
       GO TO 704
  706  Z=ABS(Y1/Y2)
       WBF=(WB2*Z+WB1)/(1.+Z)
  704  GO TO IMP
 
C   CALCULATE DRY BULB TEMPERATURE (DB) WHEN GIVEN WET BULB (WB)
C   AND RELATIVE HUMIDITY (RH)
  800  ITER1=0
       DB1=WB+1.
       DB=DB1
       ASSIGN 810 TO IOP
       GO TO 850
  810  F3=F
       DB2=DB1+2.
       DB=DB2
       ASSIGN 820 TO IOP
  815  DB=DB2
       GO TO 850
  820  F4=F
       ITER1=ITER1+1
       IF(ITER1.GT.25) GO TO INP
       DBWBRH=DB2-F4/(F4-F3)*(DB2-DB1)
       IF(ABS(DBWBRH-DB2).LT.0.01) GO TO INP
       DB1=DB2
       F3=F4
       DB2=DBWBRH
       GO TO 815
  850  CONTINUE
       ASSIGN 890 TO IKP
       GO TO 500
  890  F=RH-RH1
       GO  TO  IOP
 
  900  SHL=1.09*CFM*(EDB-LDB)
       IF(IUNITS.EQ.2) GO TO 950
       LDB=(LDB-32.)/1.8
       LWB=(LWB-32.)/1.8
       LWT=(LWT-32.)/1.8
       FLOWA=FLOWA/2.2046
       FLOW=FLOW/2.2046
       SHL=SHL*1.054
       QTW=QTW*1.054
C  OUTPUTS
  950  OUT(1)=LDB
       OUT(2)=LWB
       OUT(3)=FLOWA
       OUT(4)=LWT
       OUT(5)=FLOW
       OUT(6)=SHL
       OUT(7)=QTW-SHL
       OUT(8)=QTW
       RETURN
       END


C ********************** TALF ***********************
      FUNCTION TALF(N,THETA,XKL,REFRIN,ALPHA,RHOD)
      DIMENSION R(2),T(2),RHO(2),TAU(2),REF(2)
C.  THIS FUNCTION SUBPROGRAM CALCULATES THE TRANSMITTANCE-ABSOPRTANCE
C.  PRODUCT FOR A SOLAR COLLECTOR WITH N COVERS, A REFRACTIVE INDEX
C.  REFRIN, A KL VALUE OF XKL, AND A FLAT BLACK ABSORBER SURFACE.  THE
C.  INCIDENT RADIATION IS AT AN ANGLE THETA.  FOR THE FIRST CALL TO THIS
C.  FUNCTION BY EACH UNIT, RHOD MUST BE LESS THAN ZERO.
      PI = 4.0 * ATAN(1.0)
      IF(N.GE.1) GO TO 5
      TAUALF=ALPHA
      RETURN
5     IF(RHOD.GT.0.) GO TO 40
      THETA1=PI/3.
10    THETA2=ASIN(SIN(THETA1)/REFRIN)
      R(1)=SIN(THETA2-THETA1)
      R(2)=SIN(THETA2+THETA1)
      T(1)=R(1)/COS(THETA2-THETA1)
      T(2)=R(2)/COS(THETA2+THETA1)
      RHO(1)=R(1)*R(1)/R(2)/R(2)
      RHO(2)=T(1)*T(1)/T(2)/T(2)
      TABS=EXP(-XKL/COS(THETA2))
      DO 30 J=1,2
      T(J)=TABS*(1.-RHO(J))**2/(1.-TABS*TABS*RHO(J)*RHO(J))
      R(J)=RHO(J)*(1.+TABS*T(J))
      TAU(J)=T(J)
      REF(J)=R(J)
      IF(N.EQ.1) GO TO 30
      DO 20 I=2,N
      TAU(J)=TAU(J)*T(J)/(1.-REF(J)*R(J))
      REF(J)=REF(J)+TAU(J)*TAU(J)*R(J)/(1.-REF(J)*R(J))
20    CONTINUE
30    CONTINUE
      IF(RHOD.GT.0.) GO TO 50
C..INITIALIZE RHOD.
      RHOD=(REF(1)+REF(2))/2.
40    THETA1=THETA*PI/180.
      IF(THETA1.LT.0.001) THETA1=0.001
      GO TO 10
50    TALF=(TAU(1)+TAU(2))/2.*ALPHA/(1.-(1.-ALPHA)*RHOD)
       RETURN
       end

C ********************** DATA ***********************
C Dummy subroutine for trnsys types.
      subroutine DATA(LU2,i1,NX2,i2,THETAL,Y,INFO)
      return
      end

C This function was originally within TYPE16 subroutine
C but was removed to maintain compatability between 
C compilers.
      function eot(xx)
      EOT = -(0.1236*SIN(XX) - 0.004289*COS(XX) + 0.1539*SIN(2.*XX)
     &       + 0.06078*COS(2.*XX))
      return
      end

C ..ditto
      function angle(tt,et,shft,rdconv)
      ANGLE = ((AMOD(TT+ET,24.)-12.)*15.0 + SHFT)*RDCONV
      return
      end


C *********************** Type60 Dummy*****************

      SUBROUTINE type60(simtime,xin,out,Tinit,dtdt,par,info,icntrl,*)
      IMPLICIT NONE

      DOUBLE PRECISION  simtime, par(1), xin(1), 
     &                  out(1),Tinit(1), dtdt(1)
      INTEGER           icntrl, info(15)


      RETURN 1
      END ! of type60


C *********************** Type940 Dummy*****************

      SUBROUTINE type940(simtime,xin,out,Tinit,dtdt,par,info,icntrl,*)
      IMPLICIT NONE

      DOUBLE PRECISION  simtime, par(1), xin(1), 
     &                  out(1),Tinit(1), dtdt(1)
      INTEGER           icntrl, info(15)

      RETURN 1
      END ! of type940


C *********************** Type152 Dummy*****************

      SUBROUTINE type152(simtime,xin,out,Tinit,dtdt,par,info,icntrl,*)
      IMPLICIT NONE

      DOUBLE PRECISION  simtime, par(1), xin(1), 
     &                  out(1),Tinit(1), dtdt(1)
      INTEGER           icntrl, info(15)

      RETURN 1
      END ! of type152








