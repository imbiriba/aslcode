function varargout = add_model_to_rtp(varargin)
% function [ho hao po pao] = add_model_to_rtp(h, ha, p, pa, str);
% function                   add_model_to_rtp(fin, fout, str);
% function [ho hao po pao] = add_model_to_rtp(fin, str);
% function                   add_model_to_rtp(h, ha, p, pa, fout, str);
%  
% str = data structure containing:
%       str.model = 'ecmwf','era','merra', or other ATM model name
%       str.surface = 'usgs' - model for surface altitude and land fraction
%       str.emis    = 'wisc', 'Zhou', or other.
%
% Eg.: [h ha p pa] = rtpadd_model(h,ha,p,pa,struct('model','ecmwf','surface','usgs','emis','wisc'));
%
% Paul Schou - 2011.06.17
% Breno Imbiriba - 2012.12.05 (rewrite)

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % RTP I/O MODEL - output is head, hattr, prof, pattr,
  rtp_io_interface_nextra_args = 1; 
  rtp_input_interface;  



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % Check what is in the STR structure
  if(~exist(str))
    say('Structure argument does not exist - using defaults!');
    str=struct('model','ecmwf','surface','usgs','emis','wisc');
  end

  if(isfield(str,'model'))
    model = str.model;
  else
    model = '';
  end
  if(isfield(str,'surface'))
    surface = str.surface;
  else
    surface = '';
  end
  if(isfield(str,'emis'))
    emis = str.emis;
  else
    emis = '';
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % Add Atmospheric Model
  if(isempty(model))
    % No model request. Do nothing.

  elseif(strcmpi(model,'ecm') || strcmpi(model,'ecmwf') )
    [head hattr prof pattr] = rtpadd_ecmwf_data(head, hattr, prof, pattr);

  elseif(strcmpi(model,'era'))
    [head hattr prof pattr] = rtpadd_era_data(head, hattr, prof, pattr);

  elseif(strcmpi(model,'gfs'))
    [head hattr prof pattr] = rtpadd_gfs_data(head, hattr, prof, pattr);

  elseif(strcmpi(model,'merra') || strcmpi(model,'mra'))
    [head hattr prof pattr] = rtpadd_merra(head, hattr, prof, pattr);

  else
    say(['Unknown Model name ' model '.']);
    error('Unknown Model Name');
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % Add Land fraction/altitude
  if(isempty(surface))
    % No surface request. Do nothing.

  elseif(strcmpi(surface,'usgs')) 
    lok = abs(prof.rlat) <= 90;
    [prof.salti(lok) prof.landfrac(lok)] = usgs_deg10_dem(prof.rlat(lok),prof.rlon(lok));
  else
    say(['Unknown Surface name ' surface '.']);
    error('Unknown Surface Name');
  end

 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % Add Emissivity

  if(isempty(emis))
    % Do nothing. Continue
  elseif(strcmpi(emis,'wisc') || strcmpi(emis,'wis'))

    % Add Wiscounsin Emissivity data. 
    % Hare it needs, date
    say('Using non-interpolated Wisc Emissivity!!!');
    dv = datevec(AirsDate(prof.rtime(1))); 
    [prof emis_qual emis_str] = Prof_add_emis(prof, dv(1), dv(2), dv(3), 0, 'nearest', 2, 'all');
    pattr = set_attr(pattr,'emis',emis_str);

  elseif(strcmpi(emis,'zhou') || strcmpi(emis,'dan') || strcmpi(emis,'danzhou'))
    [head hattr prof pattr] = rtpadd_emis_DanZhou(head,hattr,prof,pattr);
    pattr = set_attr(pattr,'emis','DanZhou');
  else
    say(['Unknown emis name ' emis]);
    error('Unknown Emis');
  end
 
  % Compute rho based on the emissivity

  prof.nrho= prof.nemis;
  prof.rho = (1.0 - prof.emis)/pi;



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % RTP I/O MODEL
  rtp_output_interface;

end
