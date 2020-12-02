#!/usr/bin/env python3
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.util as cutil
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
    if metadata['var'] == 'wind':
      vmin = 0 
      vmax = 12
    elif metadata['var'] == 'hs':
      vmin = 0
      vmax = 5.5
    else:
      vmin = np.nanmin(data)
      vmax = np.nanmax(data)
    #cmap = 'viridis' #blue to yellow matlab 
    cmap = 'jet'
    cbarlabel = '%s' % (metadata['var'])
    plttitle = 'WW3 Plot of variable %s' % (metadata['var'])
    cs = ax.pcolormesh(lons, lats, data,vmin=vmin,vmax=vmax,cmap=cmap)
    cb = plt.colorbar(cs, orientation='horizontal', shrink=0.5, pad=.04)
    cb.set_label(cbarlabel, fontsize=12)
    plt.title(plttitle)
    plt.savefig(plotpath)
    plt.close('all')

def read_var(datapath, varname):
    datanc  = nc.Dataset(datapath)
    latout  = datanc.variables['latitude'][:]
    lons  = datanc.variables['longitude'][:]
    if varname == 'wind': 
      data1 = datanc.variables['uwnd'][0,...]
      data2 = datanc.variables['vwnd'][0,...]
      data = np.sqrt(np.add(np.square(data1), np.square(data2)))
    elif varname == 'current':
      data1 = datanc.variables['ucur'][0,...]
      data2 = datanc.variables['vcur'][0,...]
      data = np.sqrt(np.add(np.square(data1), np.square(data2))) 
    else:
      data = datanc.variables[varname][0,...]
    dataout, lonout = cutil.add_cyclic_point(data, coord=lons)
    data = nc.close()
    return dataout, lonout, latout


def gen_figure(inpath, outpath, varname):
    # read the files to get the 2D array to plot
    data, lons, lats = read_var(inpath, varname)
    plotpath = outpath+'/%s.png' % (varname)
    metadata ={  'var': varname,
                }
    plot_world_map(lons, lats, data, metadata, plotpath)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument('-o', '--output', help="path to output directory", default="./")
    ap.add_argument('-i', '--input', help="path to input file", required=True)
    ap.add_argument('-v', '--variable', help="variable name to plot", required=True)
    MyArgs = ap.parse_args()
    gen_figure(MyArgs.input, MyArgs.output, MyArgs.variable)
