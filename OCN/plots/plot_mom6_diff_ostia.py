#!/usr/bin/env python3
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import netCDF4 as nc
import numpy as np
from scipy import interpolate
import argparse
import glob
import os

def plot_world_map(lons, lats, data, metadata, plotpath):
    # plot generic world map
    fig = plt.figure(figsize=(12,8))
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.PlateCarree(central_longitude=0))
    ax.add_feature(cfeature.GSHHSFeature(scale='auto'))
    ax.set_extent([-180, 180, -90, 90])

    #vmin = np.nanmin(data)
    #vmax = np.nanmax(data)    
    vminmax=float(metadata['vminmaxvar'])
    vmin = -1*vminmax
    vmax = vminmax
    cmap='bwr' 
    cbarlabel = '%s' % (metadata['var'])
    plttitle = '%s' % (metadata['tag'])
    cs = ax.pcolormesh(lons, lats, data,vmin=vmin,vmax=vmax,cmap=cmap)
    cb = plt.colorbar(cs, extend='both', orientation='horizontal', shrink=0.5, pad=.04)
    cb.set_label(cbarlabel, fontsize=12)
    plt.title(plttitle)
    plt.savefig(plotpath)
    plt.close('all')

def read_var(datapath,lonname,latname, varname):
    datanc  = nc.Dataset(datapath)
    latout  = datanc.variables[latname][:]
    lonout  = datanc.variables[lonname][:]
    dataout = datanc.variables[varname][0,...]

    datanc.close()
    return dataout, lonout, latout



def read_var_data(datapath,lonname,latname, varname):
    datanc  = nc.Dataset(datapath)
    latout  = datanc.variables[latname][:]
    lonout  = datanc.variables[lonname][:]
    data = datanc.variables[varname][0,...]
    icec = datanc.variables['sea_ice_fraction'][0,...]
    dataout = np.where(np.greater_equal(icec,0.15),np.nan,data)
    datanc.close()
    return dataout, lonout, latout


def gen_figure(inpath1, inpath2, tag1, tag2, outpath, varname, vminmax):
    # read the files to get the 2D array to plot
    data1, lons, lats = read_var_data(inpath1,'lon','lat', 'analysed_sst')
    data2, lons2, lats2 = read_var(inpath2,'longitude','latitude', 'TMP_surface')
   
   
    data = data2[1:,:] - data1
    
    plotpath = outpath+'/diff_%s_minus_%s_SST.%s.png' % (tag2,tag1,vminmax)
    varnamediff='%s minus %s for %s' % (tag2,tag1,varname)
    metadata ={  'var': varname,
                 'tag': varnamediff,
                 'vminmaxvar': vminmax
                }
    plot_world_map(lons, lats, data, metadata, plotpath)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument('-o', '--output', help="path to output directory", default="./")
    ap.add_argument('-i1', '--input1', help="path to OSTIA SST file", required=True)
    ap.add_argument('-i2', '--input2', help="path to Model file (grb2->netcdf file)", required=True)
    ap.add_argument('-t1', '--tag1', help="tag description of OSTIA", required=True)
    ap.add_argument('-t2', '--tag2', help="tag description of MODEL", required=True)
    ap.add_argument('-m', '--varminmaxval', help="max/min value for plot", required=True)
    ap.add_argument('-v', '--variable', help="variable name to plot (only plots SST)", required=True)
    MyArgs = ap.parse_args()
    gen_figure(MyArgs.input1, MyArgs.input2, MyArgs.tag1, MyArgs.tag2, MyArgs.output, MyArgs.variable, MyArgs.varminmaxval)
