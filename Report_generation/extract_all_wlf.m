function [model_names, wlf_1mm, wlf_3mm, wlf_10mm, wake_length, mesh_density, mesh_scaling, n_cores, simulation_time] = extract_all_wlf(root_path, model_sets)


for sts = 1:length(model_sets)
    files = dir_list_gen_tree(fullfile(root_path, model_sets{sts}), 'mat', 1);
    wanted_files = files(contains(files, 'data_analysed_wake.mat'));
    if isempty(wanted_files)
        disp(['No analysed files found for ',model_sets{sts},', please run analyse_pp_data.'])
        continue
    else
        disp(['Getting wake loss factors for ',model_sets{sts}])
    end %if
    split_str = regexp(wanted_files, ['\',filesep], 'split');
    for ind = 1:length(wanted_files)
        current_folder = fileparts(wanted_files{ind});
        load(fullfile(current_folder, 'data_postprocessed'), 'pp_data');
        load(fullfile(current_folder, 'data_analysed_wake'),'wake_sweep_data');
        load(fullfile(current_folder, 'run_inputs'), 'modelling_inputs');
        load(fullfile(current_folder, 'data_from_run_logs.mat'), 'run_logs');
        model_names{sts,ind} = split_str{ind}{end - 2};
%         wlf(sts,ind) = wake_sweep_data.time_domain_data{end}.wake_loss_factor;
        wlf_bl_sweep = wake_sweep_data.frequency_domain_data{1, end}.extrap_data.beam_sigma_sweep.wlf;
        bl_sweep = wake_sweep_data.frequency_domain_data{1, end}.extrap_data.beam_sigma_sweep.sig_time *3E8;
        wlf_1mm(sts,ind) = interp1(bl_sweep, wlf_bl_sweep, 1E-3);
        wlf_3mm(sts,ind) = interp1(bl_sweep, wlf_bl_sweep, 3E-3);
        wlf_10mm(sts,ind) = interp1(bl_sweep, wlf_bl_sweep, 10E-3);
        wake_length(sts,ind) = (round(((wake_sweep_data.time_domain_data{1}.timebase(end)) *3e8)*100))/100;
        mesh_density(sts, ind) = modelling_inputs.mesh_stepsize;
        mesh_scaling(sts, ind) = modelling_inputs.mesh_density_scaling;
        n_cores(sts, ind) = str2num(modelling_inputs.n_cores);
%         mesh_scaling(sts, ind) = 1;
        pling = max(abs(pp_data.Wake_potential(:,2)));
        % now looking at the last ~10ps of data
        tail = max(abs(pp_data.Wake_potential(end-600:end,2)));
%         decay_to(sts,ind) = mean(abs(tail));
        simulation_time(sts, ind) = run_logs.wall_time;
        clear pp_data wake_data
    end %for
end %for

