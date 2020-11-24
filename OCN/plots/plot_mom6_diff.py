#!/usr/bin/env python3
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import netCDF4 as nc
import numpy as np
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
    #cs = ax.pcolormesh(lons, lats, data,norm=norm,cmap=cmap)
    cb = plt.colorbar(cs, extend='both', orientation='horizontal', shrink=0.5, pad=.04)
    cb.set_label(cbarlabel, fontsize=12)
    plt.title(plttitle)
    plt.savefig(plotpath)
    plt.close('all')

def read_var(datapath, varname):
    datanc  = nc.Dataset(datapath)
    latout  = datanc.variables['geolat'][:]
    lonout  = datanc.variables['geolon'][:]
    dataout = datanc.variables[varname][0,...]
    datanc.close()
    return dataout, lonout, latout


def gen_figure(inpath1, inpath2, tag1, tag2, outpath, varname, vminmax):
    # read the files to get the 2D array to plot
    data1, lons, lats = read_var(inpath1, varname)
    data2, lons2, lats2 = read_var(inpath2, varname)

    data=data1-data2
    
    plotpath = outpath+'/diff_%s%s_%s.%s.png' % (tag1,tag2,varname,vminmax)
    varnamediff='%s minus %s for %s' % (tag1,tag2,varname)
    metadata ={  'var': varname,
                 'tag': varnamediff,
                 'vminmaxvar': vminmax
                }
    plot_world_map(lons, lats, data, metadata, plotpath)

    data=100*(data1-data2)/data2

    plotpath = outpath+'/perctdiff_%s%s_%s.%s.png' % (tag1,tag2,varname, vminmax)
    varnamediff='Percent Change Difference of %s (%s - %s)/%s' % (varname, tag1, tag2, tag2)
    metadata ={  'var': varname,
                 'tag': varnamediff,
                 'vminmaxvar': vminmax
                }
    plot_world_map(lons, lats, data, metadata, plotpath)

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument('-o', '--output', help="path to output directory", default="./")
    ap.add_argument('-i1', '--input1', help="path to input file 1", required=True)
    ap.add_argument('-i2', '--input2', help="path to input file 2", required=True)
    ap.add_argument('-t1', '--tag1', help="tag description of 1", required=True)
    ap.add_argument('-t2', '--tag2', help="tag description of 2", required=True)
    ap.add_argument('-vm', '--varminmaxval', help="max/min value for plot", required=True)
    ap.add_argument('-v', '--variable', help="variable name to plot", required=True)
    MyArgs = ap.parse_args()
    gen_figure(MyArgs.input1, MyArgs.input2, MyArgs.tag1, MyArgs.tag2, MyArgs.output, MyArgs.variable, MyArgs.varminmaxval)
