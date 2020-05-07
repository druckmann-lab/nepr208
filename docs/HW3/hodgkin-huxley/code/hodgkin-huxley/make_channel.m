%% Helper function that returns a structure containing information about an ion channel
function ion_channel = make_channel(reversal_potential, max_conductance)
  ion_channel = struct('E', reversal_potential, 'gmax', max_conductance);
end
