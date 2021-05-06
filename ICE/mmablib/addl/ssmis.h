/* SSMI-S control file */
// Robert Grumbine
// 10 April 2009

#ifndef SSMIS_INCLUDE

  #define SSMIS_INCLUDE

  #define MAX_LATITUDE  88.5

/* Satellite Altitude = */
/* Antenna size = */
/* Exact operating frequencies = */

/* Define the characteristics of the data file structure */
  #define NORBITS          1
  #define NSCANS           64

/* Structures which relate to bufr decoding */
  typedef struct {
      int kwrit;
      float latitude, longitude;
      int sftg, posn;
      float t92v, t92h, t150h;
  } short_bufr;
 
  typedef struct {
      int scan_counter;
      float latitude, longitude;
      int surface_type;
      int position_num;
      float t19v, t19h, t22v, t37v, t37h, t92v, t92h, t150h;
      short_bufr hires[3];
  } bufr_point;

  typedef struct {
      int satno, year, month, day, hour, mins, secs, scan_no;
      bufr_point full[NSCANS];
  } bufr_line;

/* Declare BUFR function prototypes */
/* extern "C" int process_bufr(bufr_line *b); */
extern int process_bufr(bufr_line *b);
extern int check_bufr(bufr_line *b);
extern int check_short_bufr(short_bufr *b);
extern void zero_bufr(bufr_line *b, int i);

#endif
