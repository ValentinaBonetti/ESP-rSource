*Geometry 1.1,GEN,bed4_st2 # tag version, format, zone name
*date Thu Dec 11 13:54:11 2008  # latest file modification 
bed4_st2 is guest room four on 2nd level
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,14.00000,0.00000,3.50000  #   1
*vertex,17.50000,0.00000,3.50000  #   2
*vertex,17.50000,5.00000,3.50000  #   3
*vertex,16.00000,5.00000,3.50000  #   4
*vertex,16.00000,3.50000,3.50000  #   5
*vertex,14.00000,3.50000,3.50000  #   6
*vertex,14.00000,0.00000,7.00000  #   7
*vertex,17.50000,0.00000,7.00000  #   8
*vertex,17.50000,5.00000,7.00000  #   9
*vertex,16.00000,5.00000,7.00000  #  10
*vertex,16.00000,3.50000,7.00000  #  11
*vertex,14.00000,3.50000,7.00000  #  12
*vertex,14.79149,0.00000,4.29149  #  13
*vertex,16.70852,0.00000,4.29149  #  14
*vertex,16.70852,0.00000,6.20851  #  15
*vertex,14.79149,0.00000,6.20851  #  16
*vertex,14.84068,0.00000,4.34068  #  17
*vertex,16.65933,0.00000,4.34068  #  18
*vertex,16.65933,0.00000,6.15932  #  19
*vertex,14.84068,0.00000,6.15932  #  20
# 
# tag, number of vertices followed by list of associated vert
*edges,10,1,2,8,7,1,13,16,15,14,13  #  1
*edges,4,2,3,9,8  #  2
*edges,4,3,4,10,9  #  3
*edges,4,4,5,11,10  #  4
*edges,4,5,6,12,11  #  5
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
*surf,south,VERT,-,WALL,-,Wall_EW_noti,OPAQUE,EXTERIOR,0,0  #   1 ||< external
*surf,ptn_a,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,12,06  #   2 ||< ptn_e:bed5_st2
*surf,ptn_b,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,32,22  #   3 ||< ptn_bf:cirArea_St2
*surf,ptn_c,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,25,01  #   4 ||< ptn_a:bath3-4
*surf,ptn_d,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,25,07  #   5 ||< ptn_e:bath3-4
*surf,ptn_e,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,10,02  #   6 ||< ptn_a:bed3_st2
*surf,ceiling,CEIL,-,PARTN,-,inv_pa_fl_no,OPAQUE,ANOTHER,57,08  #   7 ||< floor:bed4_st3
*surf,floor,FLOR,-,PARTN,-,pa_fl_notion,OPAQUE,ANOTHER,01,12  #   8 ||< Base-9:eating_area
*surf,win_frame,VERT,south,F-FRAME,CLOSED,frame_notion,OPAQUE,EXTERIOR,0,0  #   9 ||< external
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