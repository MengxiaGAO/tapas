function tapas_rdcm_visualize(output, DCM, options, plot_regions)
% tapas_rdcm_visualize(output, DCM, options, plot_regions)
% 
% Generates a simple graphical output of the rDCM results. 
% 
%   Input:
%   	output          - model inversion results
%   	DCM             - model structure
%       options         - estimation options
%       plot_regions    - array of region indices
%
%   Output: 
%
 
% ----------------------------------------------------------------------
% 
% Authors: Stefan Fraessle (stefanf@biomed.ee.ethz.ch), Ekaterina I. Lomakina
% 
% Copyright (C) 2016-2018 Translational Neuromodeling Unit
%                         Institute for Biomedical Engineering
%                         University of Zurich & ETH Zurich
%
% This file is part of the TAPAS rDCM Toolbox, which is released under the 
% terms of the GNU General Public License (GPL), version 3.0 or later. You
% can redistribute and/or modify the code under the terms of the GPL. For
% further see COPYING or <http://www.gnu.org/licenses/>.
% 
% Please note that this toolbox is in an early stage of development. Changes 
% are likely to occur in future releases.
% 
% ----------------------------------------------------------------------


% default if no regions are specified
if ( nargin < 4 )
    plot_regions = 1;
end


%% visualize results

% simulation (where true parameters are known) or empirical analysis
if ( options.visualize )
    if ( options.type == 's' )
        if ( options.compute_signal )

            % visualize estimated connectivity pattern
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(2,2,1)
            imagesc(output.Ep.A)
            title('estimated','FontSize',14)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',12)
            ylabel('region (to)','FontSize',12)

            % visualize true connectivity pattern
            subplot(2,2,2)
            imagesc(DCM.Tp.A)
            title('true','FontSize',14)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',12)
            ylabel('region (to)','FontSize',12)

            % get the samples to plot
            y_source_reshape    = reshape(output.signal.y_source,length(output.signal.y_source)/size(output.Ep.A,1),size(output.Ep.A,1));
            y_pred_rdcm_reshape = reshape(output.signal.y_pred_rdcm,length(output.signal.y_source)/size(output.Ep.A,1),size(output.Ep.A,1));
            y_source_reshape    = y_source_reshape(:,plot_regions);
            y_pred_rdcm_reshape	= y_pred_rdcm_reshape(:,plot_regions);

            % visualize true and predicted BOLD signal
            subplot(2,1,2)
            hold on
            ha(1) = plot(y_source_reshape(:),'Color',[0.3 0.3 0.3]);
            ha(2) = plot(y_pred_rdcm_reshape(:),'b');
            yl = ylim;
            for int = 1:size(y_pred_rdcm_reshape,2)-1, plot([int*size(y_pred_rdcm_reshape,1) int*size(y_pred_rdcm_reshape,1)],yl,'k.-'), end
            xlim([0 numel(y_source_reshape)])
            legend(ha,{'true','predicted'},'Location','SE')
            title('true and prediced time series','FontSize',14);
            ylabel('BOLD','FontSize',12)
            xlabel('sample index','FontSize',12)

        else

            % visualize estimated connectivity pattern
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(1,2,1)
            imagesc(output.Ep.A)
            title('estimated','FontSize',16)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',14)
            ylabel('region (to)','FontSize',14)

            % visualize true connectivity pattern
            subplot(1,2,2)
            imagesc(DCM.Tp.A)
            title('true','FontSize',16)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',14)
            ylabel('region (to)','FontSize',14)

        end

    else

        if ( options.compute_signal )

            % visualize estimated connectivity pattern
            figure('units','normalized','outerposition',[0 0 1 1])
            sub1 = subplot(2,2,1);
            colormap(sub1,'parula')
            imagesc(output.Ep.A)
            title('estimated','FontSize',14)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',12)
            ylabel('region (to)','FontSize',12)

            % visualize posterior probability of binary indicator variable
            sub2 = subplot(2,2,2);
            colormap(sub2,'gray')
            imagesc(output.Ip.A)
            title('Pp binary indicator','FontSize',14)
            axis square
            caxis([0 1])
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',12)
            ylabel('region (to)','FontSize',12)

            % get the samples to plot
            y_source_reshape    = reshape(output.signal.y_source,length(output.signal.y_source)/size(output.Ep.A,1),size(output.Ep.A,1));
            y_pred_rdcm_reshape = reshape(output.signal.y_pred_rdcm,length(output.signal.y_source)/size(output.Ep.A,1),size(output.Ep.A,1));
            y_source_reshape    = y_source_reshape(:,plot_regions);
            y_pred_rdcm_reshape	= y_pred_rdcm_reshape(:,plot_regions);

            % visualize measured and predicted BOLD signal
            subplot(2,1,2);
            hold on
            ha(1) = plot(y_source_reshape(:),'Color',[0.3 0.3 0.3]);
            ha(2) = plot(y_pred_rdcm_reshape(:),'b');
            yl = ylim;
            for int = 1:size(y_pred_rdcm_reshape,2)-1, plot([int*size(y_pred_rdcm_reshape,1) int*size(y_pred_rdcm_reshape,1)],yl,'k.-'), end
            xlim([0 numel(y_source_reshape)])
            legend(ha,{'true','predicted'},'Location','SE')
            title('true and prediced time series','FontSize',14);
            ylabel('BOLD','FontSize',12)
            xlabel('sample index','FontSize',12)

        else

            % visualize estimated connectivity pattern
            figure('units','normalized','outerposition',[0 0 1 1])
            sub1 = subplot(2,2,1);
            colormap(sub1,'parula')
            imagesc(output.Ep.A)
            title('estimated','FontSize',16)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',14)
            ylabel('region (to)','FontSize',14)

            % visualize posterior probability of binary indicator variable
            sub2 = subplot(2,2,2);
            colormap(sub2,'gray')
            imagesc(output.Ip.A)
            title('Pp binary indicator','FontSize',16)
            axis square
            set(gca,'xtick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            set(gca,'ytick',[1 round(size(output.Ep.A,1)/2) size(output.Ep.A,1)])
            xlabel('region (from)','FontSize',14)
            ylabel('region (to)','FontSize',14)

        end
    end
end

end
