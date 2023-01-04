import numpy as np
#Robert Grumbine
#1 June 2018

#from const import *
import const
from ijpt import *
from latpt import *

def ok(x, loc):
  return (loc.i >= 0 and loc.i < x.shape[0] and
          loc.j >= 0 and loc.j < x.shape[1] )

#Includes only the mapping, not the data
#############################################################
class psgrid:

  def locate(self, i, j, z):
    z.lat = i
    z.lon = j


class llgrid:

  def __init__(self, dlat, dlon, firstlat, firstlon, nx, ny):
    #debug print("hello from llgrid.__init__", flush=True)
    self.dlat         = dlat
    self.dlon         = dlon
    self.firstlat     = firstlat
    self.firstlon     = firstlon
    self.nx           = nx
    self.ny           = ny
    #debug print("degree area = ",const.degree_area, flush=True)
    self.darea_base   = abs(self.dlat*self.dlon)*const.degree_area
    self.dlat_rad     = self.dlat * const.rpdg
    self.firstlat_rad = self.firstlat * const.rpdg

  def locate(self, i, j, z):
    z.lat = self.firstlat + j*self.dlat
    z.lon = self.firstlon + i*self.dlon
    while (z.lon > 360.):
      z.lon -= 360.

  def inv_locate(self, lat, lon):
    j = (lat - self.firstlat)/self.dlat
    if (lon < 0):
      i = self.nx - (self.firstlon - lon)/self.dlon
    else:
      i = (lon - self.firstlon)/self.dlon

    return(i,j)

  def cellarea(self, j, i):
    #Original:
    #tlat = self.firstlat + j*self.dlat
    #dy = (self.dlat) * 111.1
    #dx = (self.dlon) * 111.1 * cos(tlat*const.rpdg )
    #return abs(dx*dy)
    #Promote/pre-compute grid constants (darea_base) and
    #    pre-translate degrees to radians in the base class (*lat_rad)
    return (self.darea_base * cos(self.firstlat_rad + j*self.dlat_rad) )

#  def locate(self, i, j):
#    z = latpt()
#    z.lat = self.firstlat + j*self.dlat
#    z.lon = self.firstlon + i*self.dlon
#    while (z.lon > 360.):
#      z.lon -= 360.
#    return z

#############################################################

class global_5min(llgrid):

  def __init__(self, nx = 12*360, ny = 12*180):
    self.dlat = -1./12.
    self.dlon =  1./12.
    self.firstlat = 90 + self.dlat/2. 
    self.firstlon = self.dlon / 2.
    self.nx = nx
    self.ny = ny

    
class global_halfdeg(llgrid):

  def __init__(self, nx = 720, ny = 360):
    self.dlat = -0.5
    self.dlon =  0.5
    self.firstlat = 90 + self.dlat/2. 
    self.firstlon = self.dlon / 2.
    self.nx = nx
    self.ny = ny

class global_nthdeg(llgrid):

  def __init__(self, n = 1.0):
    self.dlat = -1./float(n)
    self.dlon =  1./float(n)
    self.firstlat = 90 + self.dlat/2.
    self.firstlon = self.dlon / 2.
    self.nx = 360*n
    self.ny = 180*n

    
