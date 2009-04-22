% Bidomain, axial stimulation
run_CARP('queeg','square_epicardial_potential','ep_bi_axial')
run_CARP('queeg','square_epicardial_simple_alpha','es_bi_axial')
run_CARP('queeg','square_transmural_potential','tp_bi_axial')
run_CARP('queeg','square_transmural_simple_alpha','ts_bi_axial')

% Bidomain, transmural stimulation
run_CARP('queeg','square_epicardial_potential','ep_bi_transm')
run_CARP('queeg','square_epicardial_simple_alpha','es_bi_transm')
run_CARP('queeg','square_transmural_potential','tp_bi_transm')
run_CARP('queeg','square_transmural_simple_alpha','ts_bi_transm')

% Monodomain, axial stimulation
run_CARP('queeg','square_epicardial_potential','ep_mono_axial')
run_CARP('queeg','square_epicardial_simple_alpha','es_mono_axial')
run_CARP('queeg','square_transmural_potential','tp_mono_axial')
run_CARP('queeg','square_transmural_simple_alpha','ts_mono_axial')

% Monodomain, transmural stimulation
run_CARP('queeg','square_epicardial_potential','ep_mono_transm')
run_CARP('queeg','square_epicardial_simple_alpha','es_mono_transm')
run_CARP('queeg','square_transmural_potential','tp_mono_transm')
run_CARP('queeg','square_transmural_simple_alpha','ts_mono_transm')
