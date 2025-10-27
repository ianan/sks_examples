pro get_fl20021005_a1

  ; These times/setup are those used in Flecther et. 2007, flare #3
  ; https://doi.org/10.1086/510446
  ;
  ; Entry for this flare in the archive:
  ; https://hesperia.gsfc.nasa.gov/rhessi_extras/flare_images/2002/10/05/20021005_1040_1056/hsi_20021005_1040_1056.html
  ;
  ; This is an unusual flare in that we have the shutter in (A1) before and during the flare
  ;
  ; 29-Mar-2022 IGH
  ; 01-Apr-2022 IGH Manually produce per det
  ; 26-Oct-2025 IGH Need to set sum_flag=1 even though sep det due to sunkit-spex "bug"
  ; 27-Oct-2025 IGH Make sure everything is rate as that has been tested with sunkit-spex
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Need the following line if don't already have the original data
  search_network, /enabled
  ; -----
  ; Time range for the flare
  ; btims = '05-Oct-2002 ' + ['10:38:32', '10:40:32']
  ; ftims = '05-Oct-2002 ' + ['10:41:20', '10:42:24']
  tr = '05-Oct-2002 ' + ['10:38:00', '10:44:24']
  ; Just use the same 6 detectors from the original paper
  dets = [1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  use_det = where(dets eq 1, nud)
  ; -----
  ; Energy binning of 1/3 keV binning 3-100 keV
  eres = 1 / 3.
  ebins = 3. + findgen(97 / eres + 1) * eres
  ; Units
  units = 'rate'
  ; -----
  ; -----
  ; Do the Summed version
  os = hsi_spectrum()
  os.set, obs_time_int = tr
  os.set, sp_energy_binning = ebins
  os.set, seg_index_mask = dets
  os.set, sp_data_unit = units
  os.set, sp_time_interval = 4.
  os.set, use_flare_xyoffset = 1
  os.set, sp_semi_calibrated = 0
  os.set, decimation_correct = 1
  os.set, rear_decimation_correct = 0
  os.set, pileup_correct = 0
  os.set, sum_flag = 1
  ; Write the file out
  os.filewrite, /fits, /build, simplify = 0, $
    srmfile = 'fits/' + break_time(tr[0]) + '_srm_sum.fits', $
    specfile = 'fits/' + break_time(tr[0]) + '_spec_sum.fits'
  ; -----
  ; -----
  ; Then do the per detector version
  for i = 0, nud - 1 do begin
    os = hsi_spectrum()
    os.set, obs_time_int = tr
    eres = 1 / 3.
    os.set, sp_energy_binning = ebins
    os.set, seg_index_mask = dets
    os.set, sp_data_unit = 'flux'
    os.set, sp_time_interval = 4.
    os.set, use_flare_xyoffset = 1
    os.set, sp_semi_calibrated = 0
    os.set, decimation_correct = 1
    os.set, rear_decimation_correct = 0
    os.set, pileup_correct = 0
    dets_temp = intarr(18)
    dets_temp[use_det[i]] = 1
    print, dets_temp
    os.set, seg_index_mask = dets_temp
    dname = 'd' + strcompress(string(use_det[i] + 1), /rem)
    os.set, sum_flag = 1
    os.filewrite, /fits, /build, simplify = 0, $
      srmfile = 'fits/' + break_time(tr[0]) + '_srm_' + dname + '_sf1.fits', $
      specfile = 'fits/' + break_time(tr[0]) + '_spec_' + dname + '_sf1.fits'
    obj_destroy, os
  endfor
end
