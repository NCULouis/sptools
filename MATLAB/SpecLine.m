classdef SpecLine
    %SPECLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frequency % GHz
        limitLine % depends on spec, in dB usually
        standard
        specItem
    end
    
    methods
        function self = SpecLine(standard,specItem)
            self.standard = standard;
            self.specItem = specItem;
            
            supportedStandards = {'chip-to-module CAUI4';'100GBASE-CR4'};
            
            if strcmpi(standard,'chip-to-module CAUI4')
                supportedSpecItems = {'IL';'RLd';'RLdc'};
                if strcmpi(specItem,'IL') % Maximum differential insertion loss
                    self.frequency = 0.01:0.01:18.75;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine(self.frequency<18.75) = -(1.076*(-18+2*self.frequency(self.frequency<18.75)));
                    self.limitLine(self.frequency<14) = -(1.076*(0.075+0.537*sqrt(self.frequency(self.frequency<14))+0.566*self.frequency(self.frequency<14)));
                elseif strcmpi(specItem,'RLd') % Maximum differential return loss
                    self.frequency = 0.01:0.01:19;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -(4.75-7.4*log10(self.frequency/14));
                    self.limitLine(self.frequency<12.89) = -(9.5-0.37*self.frequency(self.frequency<12.89));
                elseif strcmpi(specItem,'RLdc') % Maximum
                    self.frequency = 0.01:0.01:19;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -(15-6*(self.frequency/25.78));
                    self.limitLine(self.frequency<12.89)=-(22-20*(self.frequency(self.frequency<12.89)/25.78));
                else
                    disp('Warning: unsupported spec item');
                    disp('Supported items:');
                    disp(char(supportedSpecItems));
                end
            elseif strcmpi(standard,'100GBASE-CR4')
                supportedSpecItems = {'IL_tfref';'IL_catf';'IL_MTFmax';'IL_MTFmin'; ...
                    'RLd_MTF';'ILdc_MTF';'RLc_MTF';'RLdc_MTF'};
                if strcmpi(specItem,'IL_tfref') % Host board test fixture reference differential insertion loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -(-0.00144 + 0.13824*sqrt(self.frequency) + 0.06624*self.frequency);
                elseif strcmpi(specItem,'IL_catf') % Cable assembly test fixture reference differential insertion loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -(-0.00125 + 0.12*sqrt(self.frequency) + 0.0575*self.frequency);
                elseif strcmpi(specItem,'IL_MTFmax') % Mated test fixtures maximum differential insertion loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 0.12 + 0.475*sqrt(self.frequency) + 0.221*self.frequency);
                    self.limitLine(self.frequency>14) = -( -4.25 + 0.66*self.frequency(self.frequency>14) );
                elseif strcmpi(specItem,'IL_MTFmin') % Mated test fixtures minimum differential insertion loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 0.0656*sqrt(self.frequency) + 0.164*self.frequency);
                elseif strcmpi(specItem,'RLd_MTF') % Mated test fixtures maximum differential return loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 18 - 0.5*self.frequency);
                    self.limitLine(self.frequency<4) = -( 20 - self.frequency(self.frequency<4) );
                elseif strcmpi(specItem,'ILdc_MTF') % Mated test fixtures maximum common-mode conversion insertion loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 30 - 29/22*self.frequency );
                    self.limitLine(self.frequency>=16.5) = -( 8.25 );                    
                elseif strcmpi(specItem,'RLc_MTF') % Mated test fixtures maximum common-mode return loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 12 - 9*self.frequency );
                    self.limitLine(self.frequency>=1) = -( 3 );
                elseif strcmpi(specItem,'RLdc_MTF') % Mated test fixtures maximum common-mode to differential mode return loss
                    self.frequency = 0.01:0.01:25;
                    self.limitLine = ones(length(self.frequency),1)*NaN;
                    self.limitLine = -( 30 - 30/25.78*self.frequency);
                    self.limitLine(self.frequency>=12.89) = -( 18 - 6/25.78*self.frequency(self.frequency>=12.89) );
                else
                    disp(['Warning: unsupported spec item, ' self.specItem]);
                    disp('Supported items:');
                    disp(char(supportedSpecItems));
                end
            else
                disp('Warning: unsupported standard');
                disp('Supported standards:');
                disp(char(supportedStandards));
            end
        end
        
        function addToPlot(self,figureHandle,plotSpec)
            if nargin>1 && figureHandle
                figure(figureHandle);
            end
            if nargin<3
                plotSpec = 'k--';
            end
            [~,~,~,OUTM] = legend;
            hold on;
            plot(self.frequency,self.limitLine,plotSpec);
            hold off;
            OUTM{end+1} = [ self.standard ' ' regexprep(self.specItem,'(.*)_(.*)$','$1_{$2}') ];
            LH=legend(OUTM,'Location','Best');
        end
               
    end
    
end
