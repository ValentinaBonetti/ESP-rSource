# geometry of Elev_3 defined in: Elev_3.geo
GEN  Elev_3  Elev_3 describes a...  # type, name, descr
      10       6   0.000    # vertices, surfaces, rotation angle
#  X co-ord, Y co-ord, Z co-ord
      1.20000     7.20000     9.50000  # vert   1
      1.20000    11.30000     9.50000  # vert   2
     -0.10000    11.30000     9.50000  # vert   3
     -0.10000     7.20000     9.50000  # vert   4
      1.20000     7.20000    12.35000  # vert   5
      1.20000    11.30000    12.35000  # vert   6
     -0.10000    11.30000    12.35000  # vert   7
     -0.10000     7.20000    12.35000  # vert   8
      1.20000     7.20000    12.10000  # vert   9
      1.20000    11.30000    12.10000  # vert  10
# no of vertices followed by list of associated vert
   6,  1,  2, 10,  6,  5,  9,
   5,  2,  3,  7,  6, 10,
   4,  3,  4,  8,  7,
   5,  4,  1,  9,  5,  8,
   4,  5,  6,  7,  8,
   4,  1,  4,  3,  2,
# unused index
  0 0 0 0 0 0
# surfaces indentation (m)
 0.000 0.000 0.000 0.000 0.000 0.000
    3   0   0   0    # default insolation distribution
# surface attributes follow: 
# id  surface      geom  loc/  mlc db       environment
# no  name         type  posn  name         other side
  1, Surf-1        OPAQ  VERT  Int_wall     SIMILAR        
  2, Surf-2        OPAQ  VERT  Facade_vent  EXTERIOR       
  3, Surf-3        OPAQ  VERT  Facade_vent  EXTERIOR       
  4, Surf-4        OPAQ  VERT  Facade_vent  EXTERIOR       
  5, Surf-5        TRAN  CEIL  fictious     Elev_4         
  6, Surf-6        TRAN  FLOR  fictious     Elev_2         
# base
  6  0  0  0  0  0     5.33
