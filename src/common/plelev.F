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

C PLELEV: Scales and draws a site plan/elev showing zone & obstructions.

C NOTE: This version of PELEV is no longer called. All code now uses
C the version in plelevvc.F

C ************* PLELEV
C PLELEV Scales and draws a plan or elevation of a model
C and the surrounding obstruction blocks. direc is
C a character S, E, P,  ie. S gives a south elevation and
C P gives a plan.  Inpic is the number of zones, ivals is a
C array of selected zones to include.
C IUF is file unit for geometry, utility file units.
      SUBROUTINE PLELEV(IUF,direc,ier)
#include "building.h"
#include "model.h"

C geometry.h provides commons G0/G1/G2/precz/GS5/GS6.
#include "geometry.h"
#include "prj3dv.h"
      
      integer lnblnk  ! function definition

      COMMON/SPAD/MMOD,LIMIT,LIMTTY
      COMMON/OUTIN/IUOUT,IUIN
      COMMON/gzonpik/izgfoc,nzg,nznog(mcom)

      COMMON/GB1/XB(12),YB(12),ZB(12),JVNB(6,4)
      common/grndpl/NGT,NGTV,XGT(MGTV),YGT(MGTV),ZGT(MGTV),JGVN(MGRT,8),
     &  NGVER(MGRT),IVEDGE(MGRT)

      integer menuchw,igl,igr,igt,igb,igw,igwh
      COMMON/VIEWPX/menuchw,igl,igr,igt,igb,igw,igwh
      integer ifs,itfs,imfs
      COMMON/GFONT/IFS,ITFS,IMFS

      CHARACTER sstr*90,blabel*4,direc*1
      character tz*13
#ifdef OSI
      integer igwid,igheight  ! for use with axiscale
      integer iupdown,isym,iix,iiy,iid1,iid2    ! passed to etplot
      integer iigl,iigr,iigt,iigb,iigw,iigwh
      integer iiw1,iiw2,iiw3,iiw4,iimenu
#else
      integer*8 igwid,igheight  ! for use with axiscale
      integer*8 iupdown,isym,iix,iiy,iid1,iid2    ! passed to etplot
      integer*8 iigl,iigr,iigt,iigb,iigw,iigwh
      integer*8 iiw1,iiw2,iiw3,iiw4,iimenu
#endif

      IER=0
      IF(MMOD.LT.8)THEN
        CALL USRMSG('Not in graphic mode...',' ','W')
        RETURN
      ENDIF

C Define a viewing box, draw its border after clearing it and
C return the offsets which define it. Recalculate igw and igwh
C on fortran to address fault in 64 bit win3d code.
      call startbuffer()
      if(menuchw.ne.0)then

C Setup and pass in parameters to win3d.
        iiw1=7; iiw2=4; iiw3=3; iiw4=3; iimenu=menuchw
        iigl=igl; iigr=igr; iigt=igt; iigb=igb; iigw=igw; iigwh=igwh
        CALL win3d(iimenu,iiw1,iiw2,iiw3,iiw4,
     &    iigl,iigr,iigt,iigb,iigw,iigwh)
      else
        iiw1=7; iiw2=4; iiw3=3; iiw4=3; iimenu=32
        iigl=igl; iigr=igr; iigt=igt; iigb=igb; iigw=igw; iigwh=igwh
        CALL win3d(iimenu,iiw1,iiw2,iiw3,iiw4,
     &    iigl,iigr,iigt,iigb,iigw,iigwh)
      endif
      igl=int(iigl); igr=int(iigr); igt=int(iigt); igb=int(iigb)
      igw=int(iigw); igwh=int(iigwh)
      igwid=igw
      igheight=igwh
      
C Reopen the dialogue box.
      CALL USRMSG(' ',' ','-')

C Depending on plan or elevation views:
C Determine scaling ratios for the drawing and axis.
C Place scaling in static C variables for use by line drawing routines.
C Draw a scale horizontal axis, move to beginning point.
C Draw a scale vertical axis.
      if(direc.eq.'P')then
        CALL axiscale(igwid,igheight,XMN,XMX,YMN,YMX,xsc,ysc,sca,
     &    Xadd,Yadd)
        call linescale(iigl,Xadd,sca,iigb,Yadd,sca)
        call dintervalf(XMN,XMX,DY,NDEC,1)
        CALL horaxisdd(XMN,XMX,iigl,iigr,iigb,Xadd,sca,1,
     &    DY,NDEC,'East (m) ->')
        call dintervalf(YMN,YMX,DY,NDEC,1)
        CALL vrtaxisdd(YMN,YMX,iigl,iigb,iigt,Yadd,sca,1,
     &    DY,NDEC,0,'^ North')
      elseif(direc.eq.'S')then
        CALL axiscale(igwid,igheight,XMN,XMX,ZMN,ZMX,xsc,ysc,sca,
     &    Xadd,Yadd)
        call linescale(iigl,Xadd,sca,iigb,Yadd,sca)
        call dintervalf(XMN,XMX,DY,NDEC,1)
        call horaxisdd(XMN,XMX,iigl,iigr,iigb,Xadd,sca,1,
     &    DY,NDEC,'East (m) ->')
        call dintervalf(ZMN,ZMX,DY,NDEC,1)
        call vrtaxisdd(ZMN,ZMX,iigl,iigb,iigt,Yadd,sca,1,
     &    DY,NDEC,0,'^ Up')
      elseif(direc.eq.'E')then
        CALL axiscale(igwid,igheight,YMN,YMX,ZMN,ZMX,xsc,ysc,sca,
     &    Xadd,Yadd)
        call linescale(iigl,Xadd,sca,iigb,Yadd,sca)
        call dintervalf(XMN,XMX,DY,NDEC,1)
        call horaxisdd(YMN,YMX,iigl,iigr,iigb,Xadd,sca,1,
     &    DY,NDEC,'North (m) ->')
        call dintervalf(ZMN,ZMX,DY,NDEC,1)
        call vrtaxisdd(ZMN,ZMX,iigl,iigb,iigt,Yadd,sca,1,
     &    DY,NDEC,0,'^ Up')
      endif

C Loop through each of the selected zones, read geometry
C file and plot it. Move to first vertex and give the zone name.
      newpic=nzg
      do 54 mz=1,newpic
        newfoc=nznog(mz)
        call georead(IUF,LGEOM(newfoc),newfoc,0,IUOUT,IER)

C Check for a zone obstructions file.
        if(IOBS(newfoc).EQ.1)then
          CALL EGOMST(IUF,newfoc,ZOBS(newfoc),0,0,iuout,IER)
        elseif(IOBS(newfoc).EQ.2)then
          continue
        endif

        if(direc.eq.'P')then
          call u2pixel(ZCOG(newfoc,1),ZCOG(newfoc,2),iix,iiy)
          iupdown=0
          isym=0
          call etplot(ZCOG(newfoc,1),ZCOG(newfoc,2),iupdown,isym)
        elseif(direc.eq.'S')then
          call u2pixel(ZCOG(newfoc,1),ZCOG(newfoc,3),iix,iiy)
          iupdown=0
          isym=0
          call etplot(ZCOG(newfoc,1),ZCOG(newfoc,3),iupdown,isym)
        elseif(direc.eq.'E')then
          call u2pixel(ZCOG(newfoc,2),ZCOG(newfoc,3),iix,iiy)
          iupdown=0
          isym=0
          call etplot(ZCOG(newfoc,2),ZCOG(newfoc,3),iupdown,isym)
        endif
        IF(lnzname(newfoc).GT.1)THEN
          write(tz,'(A)')zname(newfoc)
          call winfnt(ITFS)
          iid1=iix+2; iid2=iiy-2;
          call wstxpt(iid1,iid2,tz)
        ELSE
          call winfnt(ITFS)
          iid1=iix+2; iid2=iiy-2;
          call wstxpt(iid1,iid2,'Target')
        endif

        DO 400 I=1,NSUR
          J=JVN(I,1)
          iupdown=0
          isym=0
          if(direc.eq.'P')call etplot(X(J),Y(J),iupdown,isym)
          if(direc.eq.'S')call etplot(X(J),Z(J),iupdown,isym)
          if(direc.eq.'E')call etplot(Y(J),Z(J),iupdown,isym)

          K=NVER(I)
          DO 50 L=2,K
            M=JVN(I,L)
            iupdown=-302
            isym=0
            if(direc.eq.'P')call etplot(X(M),Y(M),iupdown,isym)
            if(direc.eq.'S')call etplot(X(M),Z(M),iupdown,isym)
            if(direc.eq.'E')call etplot(Y(M),Z(M),iupdown,isym)
   50     CONTINUE
          iupdown=-302
          isym=0
          if(direc.eq.'P')call etplot(X(J),Y(J),iupdown,isym)
          if(direc.eq.'S')call etplot(X(J),Z(J),iupdown,isym)
          if(direc.eq.'E')call etplot(Y(J),Z(J),iupdown,isym)
  400   CONTINUE
        call forceflush()

C Now draw each obstruction block by first converting to GB1
C common block via CNVBLK.
        if(nbobs(newfoc).eq.0)goto 54
        DO 420 IB= 1,nbobs(newfoc)
          CALL CNVBLK(XOB(newfoc,IB),YOB(newfoc,IB),ZOB(newfoc,IB),
     &      DXOB(newfoc,IB),DYOB(newfoc,IB),DZOB(newfoc,IB),
     &      BANGOB(newfoc,IB,1))
          DO 422 I=1,6   ! for each surface in the block
            J=JVNB(I,1)
            iupdown=0
            isym=0
            if(direc.eq.'P')call etplot(XB(J),YB(J),iupdown,isym)
            if(direc.eq.'S')call etplot(XB(J),ZB(J),iupdown,isym)
            if(direc.eq.'E')call etplot(YB(J),ZB(J),iupdown,isym)
            K=4          ! for each edge of block surface
            DO 424 L=2,K
              M=JVNB(I,L)
              iupdown=1
              isym=0
              if(direc.eq.'P')call etplot(XB(M),YB(M),iupdown,isym)
              if(direc.eq.'S')call etplot(XB(M),ZB(M),iupdown,isym)
              if(direc.eq.'E')call etplot(YB(M),ZB(M),iupdown,isym)
  424       CONTINUE
            iupdown=1
            isym=0
            if(direc.eq.'P')call etplot(XB(J),YB(J),iupdown,isym)
            if(direc.eq.'S')call etplot(XB(J),ZB(J),iupdown,isym)
            if(direc.eq.'E')call etplot(YB(J),ZB(J),iupdown,isym)
  422     CONTINUE
          if(direc.eq.'P')call u2pixel(XB(J),YB(J),iix,iiy)
          if(direc.eq.'S')call u2pixel(XB(J),ZB(J),iix,iiy)
          if(direc.eq.'E')call u2pixel(YB(J),ZB(J),iix,iiy)
          WRITE(blabel,423)IB
  423     FORMAT('B',I2)
          iid1=iix+4; iid2=iiy-4;
          call wstxpt(iid1,iid2,blabel)
  420   CONTINUE
  54  continue
      call forceflush()

C If there is a ground, ITDSP is flagged and plan view draw it.
      IF(ITDSP.EQ.5.and.NGT.gt.0)then
        if(direc.eq.'P')then
          DO 401 I=1,NGT
            J=JGVN(I,1)
            iupdown=0
            isym=0
            call etplot(XGT(J),YGT(J),iupdown,isym)
            K=NGVER(I)
            iupdown=-203
            isym=0
            DO 501 L=2,K
              M=JGVN(I,L)
              call etplot(X(M),Y(M),iupdown,isym)
  501       CONTINUE
            call etplot(X(J),Y(J),iupdown,isym)
  401     CONTINUE
        endif
      endif

C Print labels and return to default font.
      call winfnt(IFS)
      if(direc.eq.'P')then
        WRITE(sstr,'(a,a)')'Site Plan of: ',
     &    modeltitle(1:lnblnk(modeltitle))
      elseif(direc.eq.'S')then
        WRITE(sstr,'(a,a)')'South elev of: ',
     &    modeltitle(1:lnblnk(modeltitle))
      elseif(direc.eq.'E')then
        WRITE(sstr,'(a,a)')'East elev of: ',
     &    modeltitle(1:lnblnk(modeltitle))
      endif
      iiy= igt-10
      iix = igl
      call wstxpt(iix,iiy,sstr)
      call forceflush()

C If izgfoc is not zero and nzg is one and there is an obstructions
C file then reload current zone geometry file before returning.

C << this may not be necessary if newgeo is true >>

      if(nzg.eq.1.and.izgfoc.gt.0)then
        newfoc=izgfoc
        IF(IOBS(newfoc).EQ.1)THEN
          call georead(IUF,LGEOM(newfoc),newfoc,0,IUOUT,IER)
        endif
      endif
      RETURN
      END
