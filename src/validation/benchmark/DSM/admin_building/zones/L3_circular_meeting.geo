*Geometry 1.1,GEN,L3_circular # tag version, format, zone name
*date Thu Aug 11 20:40:41 2011  # latest file modification 
L3_circular describes circular meeting room at level three
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,28.92676,7.59981,56.35000  #   1
*vertex,27.88179,8.35979,56.35000  #   2
*vertex,27.88179,8.35979,60.25000  #   3
*vertex,28.92676,7.59981,60.25000  #   4
*vertex,27.21681,9.30976,56.35000  #   5
*vertex,27.21681,9.30976,60.25000  #   6
*vertex,26.93181,10.54473,56.35000  #   7
*vertex,26.93181,10.54473,60.25000  #   8
*vertex,26.97931,11.68470,56.35000  #   9
*vertex,26.97931,11.68470,60.25000  #  10
*vertex,27.40680,12.77717,56.35000  #  11
*vertex,27.40680,12.77717,60.25000  #  12
*vertex,28.07178,13.63215,56.35000  #  13
*vertex,28.07178,13.63215,60.25000  #  14
*vertex,29.16426,14.39213,56.35000  #  15
*vertex,29.16426,14.39213,60.25000  #  16
*vertex,30.39923,14.67713,56.35000  #  17
*vertex,30.39923,14.67713,60.25000  #  18
*vertex,31.53920,14.62963,56.35000  #  19
*vertex,31.53920,14.62963,60.25000  #  20
*vertex,32.96416,14.01214,56.35000  #  21
*vertex,32.96416,14.01214,60.25000  #  22
*vertex,34.25000,13.06217,56.35000  #  23
*vertex,34.25000,13.06217,60.25000  #  24
*vertex,34.50000,12.11219,56.35000  #  25
*vertex,34.50000,12.11219,60.25000  #  26
*vertex,34.60000,10.97222,56.35000  #  27
*vertex,34.60000,10.97222,60.25000  #  28
*vertex,34.38913,9.92725,56.35000  #  29
*vertex,34.38913,9.92725,60.25000  #  30
*vertex,33.86664,8.78728,56.35000  #  31
*vertex,33.86664,8.78728,60.25000  #  32
*vertex,31.35752,8.18413,56.35000  #  33
*vertex,31.35752,8.18413,60.25000  #  34
*vertex,31.50336,8.21918,56.35000  #  35
*vertex,31.50336,8.21919,60.24999  #  36
*vertex,28.07178,13.63215,59.49300  #  37
*vertex,29.16426,14.39213,59.49300  #  38
*vertex,30.39923,14.67713,59.49300  #  39
*vertex,31.53920,14.62963,59.49300  #  40
*vertex,32.96416,14.01214,59.49300  #  41
*vertex,34.25000,13.06217,59.49300  #  42
# 
# tag, number of vertices followed by list of associated vert
*edges,4,2,1,4,3  #  1
*edges,4,5,2,3,6  #  2
*edges,4,7,5,6,8  #  3
*edges,4,9,7,8,10  #  4
*edges,4,11,9,10,12  #  5
*edges,5,13,11,12,14,37  #  6
*edges,4,15,13,37,38  #  7
*edges,4,17,15,38,39  #  8
*edges,4,19,17,39,40  #  9
*edges,4,21,19,40,41  # 10
*edges,4,23,21,41,42  # 11
*edges,5,25,23,42,24,26  # 12
*edges,4,27,25,26,28  # 13
*edges,4,29,27,28,30  # 14
*edges,4,31,29,30,32  # 15
*edges,4,1,33,34,4  # 16
*edges,4,33,35,36,34  # 17
*edges,4,35,31,32,36  # 18
*edges,18,4,34,36,32,30,28,26,24,22,20,18,16,14,12,10,8,6,3  # 19
*edges,18,1,2,5,7,9,11,13,15,17,19,21,23,25,27,29,31,35,33  # 20
*edges,4,42,41,22,24  # 21
*edges,4,41,40,20,22  # 22
*edges,4,40,39,18,20  # 23
*edges,4,39,38,16,18  # 24
*edges,4,38,37,14,16  # 25
# 
# surf attributes:
#  surf name, surf position VERT/CEIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,seg_a,VERT,-,-,-,gyp_ins_gyp,OPAQUE,ANOTHER,35,27  #   1 ||< seg_a:L3_ent_void
*surf,seg_b,VERT,-,-,-,glaz_ptn,OPAQUE,ANOTHER,35,28  #   2 ||< seg_b:L3_ent_void
*surf,seg_c,VERT,-,-,-,glaz_ptn,OPAQUE,ANOTHER,35,29  #   3 ||< seg_c:L3_ent_void
*surf,seg_d,VERT,-,-,-,glaz_ptn,OPAQUE,ANOTHER,35,30  #   4 ||< seg_d:L3_ent_void
*surf,seg_e,VERT,-,-,-,glaz_ptn,OPAQUE,ANOTHER,35,31  #   5 ||< seg_e:L3_ent_void
*surf,seg_f,VERT,-,-,-,gyp_ins_gyp,OPAQUE,ANOTHER,35,32  #   6 ||< seg_f:L3_ent_void
*surf,seg_g,VERT,-,-,-,gyp_ins_gyp,OPAQUE,UNKNOWN,0,0  #   7 ||< not yet defined
*surf,seg_h,VERT,-,-,-,gyp_ins_gyp,OPAQUE,UNKNOWN,0,0  #   8 ||< not yet defined
*surf,seg_i,VERT,-,-,-,gyp_ins_gyp,OPAQUE,UNKNOWN,0,0  #   9 ||< not yet defined
*surf,seg_j,VERT,-,-,-,gyp_ins_gyp,OPAQUE,UNKNOWN,0,0  #  10 ||< not yet defined
*surf,seg_k,VERT,-,-,-,gyp_ins_gyp,OPAQUE,UNKNOWN,0,0  #  11 ||< not yet defined
*surf,seg_l,VERT,-,-,-,glaz_ptn,SCF8477_10nb,ANOTHER,37,01  #  12 ||< seg_ac:L3_void_cir
*surf,seg_m,VERT,-,-,-,glaz_ptn,SCF8477_10nb,ANOTHER,37,02  #  13 ||< seg_bc:L3_void_cir
*surf,seg_n,VERT,-,-,-,glaz_ptn,SCF8477_10nb,ANOTHER,37,03  #  14 ||< seg_cc:L3_void_cir
*surf,seg_o,VERT,-,-,-,gyp_ins_gyp,OPAQUE,ANOTHER,37,04  #  15 ||< seg_dc:L3_void_cir
*surf,facade_a,VERT,-,-,-,db_lpasol,DSF4554_06nb,UNKNOWN,0,0  #  16 ||< not yet defined
*surf,frame,VERT,-,-,-,mull_90,OPAQUE,EXTERIOR,0,0  #  17 ||< external
*surf,facade_b,VERT,-,-,-,db_lpasol,DSF4554_06nb,EXTERIOR,0,0  #  18 ||< external
*surf,Top,CEIL,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  19 ||< not yet defined
*surf,Base,FLOR,-,-,-,slab_275,OPAQUE,ANOTHER,19,19  #  20 ||< Top:L2_circular
*surf,seg_kup,VERT,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  21 ||< external
*surf,seg_jup,VERT,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  22 ||< external
*surf,seg_iup,VERT,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  23 ||< external
*surf,seg_hup,VERT,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  24 ||< external
*surf,seg_gup,VERT,-,-,-,slab_275,OPAQUE,UNKNOWN,0,0  #  25 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,0,42.00,0  # zone base