*Geometry 1.1,GEN,bed10_st2 # tag version, format, zone name
*date Thu Dec 11 13:57:44 2008  # latest file modification 
bed10_st2 is guest room ten on 2nd level
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,7.00000,8.00000,3.50000  #   1
*vertex,9.00000,8.00000,3.50000  #   2
*vertex,9.00000,6.50000,3.50000  #   3
*vertex,10.50000,6.50000,3.50000  #   4
*vertex,10.50000,11.50000,3.50000  #   5
*vertex,7.00000,11.50000,3.50000  #   6
*vertex,7.00000,8.00000,7.00000  #   7
*vertex,9.00000,8.00000,7.00000  #   8
*vertex,9.00000,6.50000,7.00000  #   9
*vertex,10.50000,6.50000,7.00000  #  10
*vertex,10.50000,11.50000,7.00000  #  11
*vertex,7.00000,11.50000,7.00000  #  12
*vertex,9.70851,11.50000,4.29149  #  13
*vertex,7.79149,11.50000,4.29149  #  14
*vertex,7.79149,11.50000,6.20851  #  15
*vertex,9.70851,11.50000,6.20851  #  16
*vertex,9.65932,11.50000,4.34068  #  17
*vertex,7.84068,11.50000,4.34068  #  18
*vertex,7.84068,11.50000,6.15932  #  19
*vertex,9.65932,11.50000,6.15932  #  20
# 
# tag, number of vertices followed by list of associated vert
*edges,4,1,2,8,7  #  1
*edges,4,2,3,9,8  #  2
*edges,4,3,4,10,9  #  3
*edges,4,4,5,11,10  #  4
*edges,10,5,6,12,11,5,13,16,15,14,13  #  5
*edges,4,6,1,7,12  #  6
*edges,6,7,8,9,10,11,12  #  7
*edges,6,1,6,5,4,3,2  #  8
*edges,10,13,14,15,16,13,17,20,19,18,17  #  9
*edges,4,17,18,19,20  # 10
# 
# surf attributes:
#  surf name, surf position VERT/CEIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,ptn_a,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,28,07  #   1 ||< ptn_e:bath9-10
*surf,ptn_b,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,28,02  #   2 ||< ptn_b:bath9-10
*surf,ptn_c,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,32,31  #   3 ||< ptn_cd:cirArea_St2
*surf,ptn_d,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,18,06  #   4 ||< ptn_e:bed11_st2
*surf,north,VERT,-,WALL,-,Wall_EW_noti,OPAQUE,EXTERIOR,0,0  #   5 ||< external
*surf,ptn_e,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,16,04  #   6 ||< ptn_d:bed9_st2
*surf,ceiling,CEIL,-,PARTN,-,inv_pa_fl_no,OPAQUE,ANOTHER,49,08  #   7 ||< floor:bed10_st3
*surf,floor,FLOR,-,PARTN,-,pa_fl_notion,OPAQUE,ANOTHER,04,08  #   8 ||< Base-10:cell_office
*surf,win_frame,VERT,north,F-FRAME,CLOSED,frame_notion,OPAQUE,EXTERIOR,0,0  #   9 ||< external
*surf,win_glz,VERT,win_frame,C-WINDOW,CLOSED,window_Not_G,Glaz_notiona,EXTERIOR,0,0  #  10 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,1,8,    14.50 0  # zone base list
# 
*bridge_start,0.100,1.106,1.106,11.056  # user fraction,losspercent W/K, total heat loss W/K and total UA W/K
*end_bridge