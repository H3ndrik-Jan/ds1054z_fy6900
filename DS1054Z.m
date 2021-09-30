classdef DS1054Z < handle
    %DS1054Z Interface for Rigol DS1054Z Oscilloscope 
    %   
    %   h = DS1054Z( RSC_ADDR )
    %
    %   Scott Stobbe 2016
    
    properties (SetAccess = protected, Transient = true)
%         RSRC_ADDR
        com
        MFG
        PN
        SN
        FW_VER
    end
    
    properties (Dependent = true)% public 
        CHAN1_BWL
        CHAN1_COUP
        CHAN1_DISP
        CHAN1_INV
        CHAN1_OFFS
        CHAN1_RANG
        CHAN1_TCAL
        CHAN1_SCAL
        CHAN1_PROB
        CHAN1_UNIT
        CHAN1_VERN
        CHAN2_BWL
        CHAN2_COUP
        CHAN2_DISP
        CHAN2_INV
        CHAN2_OFFS
        CHAN2_RANG
        CHAN2_TCAL
        CHAN2_SCAL
        CHAN2_PROB
        CHAN2_UNIT
        CHAN2_VERN
        CHAN3_BWL
        CHAN3_COUP
        CHAN3_DISP
        CHAN3_INV
        CHAN3_OFFS
        CHAN3_RANG
        CHAN3_TCAL
        CHAN3_SCAL
        CHAN3_PROB
        CHAN3_UNIT
        CHAN3_VERN
        CHAN4_BWL
        CHAN4_COUP
        CHAN4_DISP
        CHAN4_INV
        CHAN4_OFFS
        CHAN4_RANG
        CHAN4_TCAL
        CHAN4_SCAL
        CHAN4_PROB
        CHAN4_UNIT
        CHAN4_VERN
        DISP_TYPE
        DISP_PERS_TIME
        DISP_WAVE_BR
        DISP_GRID
        DISP_GRID_BR
        T_SCALE
        T_OFFSET
        T_MODE
        SRATE
        MDEPTH
        TRIG_HOLDOFF
        TRIG_EDGE_CHN
        TRIG_EDGE_SLOPE
        TRIG_EDGE_LEVEL
        TRIG_SWEEP
        TRIG_STATUS
        WREC_FEND
        WREC_FMAX
        WREC_FINT
        WREC_PROM
        WREC_OPER
        WREC_ENAB
        WPLAY_FSTART
        WPLAY_FEND
        WPLAY_FMAX
        WPLAY_FINT
        WPLAY_MODE
        WPLAY_DIR
        WPLAY_OPER
        WPLAY_FCUR
    end
    
    
    methods
        % DS1054Z Constructor
        function obj = DS1054Z( IP )
            
            obj.com = tcpip(IP, 5555);
            
                         
            try
                obj.com.InputBufferSize = 550000;
                fopen(obj.com);
            catch
                obj.com = [];
                error('Could Not Find Resource');
            end
            
%             obj.PN = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.MODEL_NAME)));
%             obj.SN = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.USB_SERIAL_NUM)));
%             obj.MFG = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.MANF_NAME)));
        end
        
        % DS1054Z Destructor
        %
        % Close comm channels
        function delete(obj)
%             obj.vCom.Close();
            fclose(obj.com);
            delete(obj.com);
        end 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 1     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN1_BWL getter
        function val = get.CHAN1_BWL(obj)
            resp = query(obj.com,':CHAN1:BWL?');
%             fprintf(obj.com.vCom,':CHAN1:BWL?');
%             resp = fgetl(obj.vCom);
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN1_BWL setter
       function obj = set.CHAN1_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          fprintf(obj.com,[':CHAN1:BWL ' s ] );
       end
       
       
       % CHAN1_COUP getter
        function val = get.CHAN1_COUP(obj)
            resp = query(obj.com,':CHAN1:COUP?');
            val = deblank(resp);
        end
        
        % CHAN1_COUP setter
        function obj = set.CHAN1_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            fprintf(obj.com,[':CHAN1:COUP ' deblank(val) ] );
        end
 
        % CHAN1_DISP getter
        function val = get.CHAN1_DISP(obj)
          resp = query(obj.com,':CHAN1:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_DISP setter
        function obj = set.CHAN1_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN1:DISP ' cmd{val+1} ] );
        end
        
        % CHAN1_INV getter
        function val = get.CHAN1_INV(obj)
          resp = query(obj.com,':CHAN1:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_INV setter
        function obj = set.CHAN1_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN1:INV ' cmd{val+1} ] );
        end
        
        % CHAN1_OFFS getter
        function val = get.CHAN1_OFFS(obj)
          resp = query(obj.com,':CHAN1:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_OFFS setter
        function obj = set.CHAN1_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            fprintf(obj.com,[':CHAN1:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_RANG getter
        function val = get.CHAN1_RANG(obj)
          resp = query(obj.com,':CHAN1:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_RANG setter
        function obj = set.CHAN1_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            fprintf(obj.com,[':CHAN1:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_TCAL getter
        function val = get.CHAN1_TCAL(obj)
          resp = query(obj.com,':CHAN1:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_TCAL setter
        function obj = set.CHAN1_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            fprintf(obj.com,[':CHAN1:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_SCAL getter
        function val = get.CHAN1_SCAL(obj)
          resp = query(obj.com,':CHAN1:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_SCAL setter
        function obj = set.CHAN1_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            fprintf(obj.com,[':CHAN1:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_PROB getter
        function val = get.CHAN1_PROB(obj)
          resp = query(obj.com,':CHAN1:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_PROB setter
        function obj = set.CHAN1_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            fprintf(obj.com,[':CHAN1:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_UNIT getter
        function val = get.CHAN1_UNIT(obj)
          resp = query(obj.com,':CHAN1:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN1_UNIT setter
        function obj = set.CHAN1_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            fprintf(obj.com,[':CHAN1:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN1_VERN getter
        function val = get.CHAN1_VERN(obj)
          resp = query(obj.com,':CHAN1:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_VERN setter
        function obj = set.CHAN1_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN1:VERN ' cmd{val+1} ] );
 
        end
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 1     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN2_BWL getter
        function val = get.CHAN2_BWL(obj)
            resp = query(obj.com,':CHAN2:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN2_BWL setter
       function obj = set.CHAN2_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          fprintf(obj.com,[':CHAN2:BWL ' s ] );
       end
       
       
       % CHAN2_COUP getter
        function val = get.CHAN2_COUP(obj)
            resp = query(obj.com,':CHAN2:COUP?');
            val = deblank(resp);
        end
        
        % CHAN2_COUP setter
        function obj = set.CHAN2_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            fprintf(obj.com,[':CHAN2:COUP ' deblank(val) ] );
        end
 
        % CHAN2_DISP getter
        function val = get.CHAN2_DISP(obj)
          resp = query(obj.com,':CHAN2:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_DISP setter
        function obj = set.CHAN2_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN2:DISP ' cmd{val+1} ] );
        end
        
        % CHAN2_INV getter
        function val = get.CHAN2_INV(obj)
          resp = query(obj.com,':CHAN2:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_INV setter
        function obj = set.CHAN2_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN2:INV ' cmd{val+1} ] );
        end
        
        % CHAN2_OFFS getter
        function val = get.CHAN2_OFFS(obj)
          resp = query(obj.com,':CHAN2:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_OFFS setter
        function obj = set.CHAN2_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            fprintf(obj.com,[':CHAN2:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_RANG getter
        function val = get.CHAN2_RANG(obj)
          resp = query(obj.com,':CHAN2:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_RANG setter
        function obj = set.CHAN2_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            fprintf(obj.com,[':CHAN2:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_TCAL getter
        function val = get.CHAN2_TCAL(obj)
          resp = query(obj.com,':CHAN2:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_TCAL setter
        function obj = set.CHAN2_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            fprintf(obj.com,[':CHAN2:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_SCAL getter
        function val = get.CHAN2_SCAL(obj)
          resp = query(obj.com,':CHAN2:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_SCAL setter
        function obj = set.CHAN2_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            fprintf(obj.com,[':CHAN2:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_PROB getter
        function val = get.CHAN2_PROB(obj)
          resp = query(obj.com,':CHAN2:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_PROB setter
        function obj = set.CHAN2_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            fprintf(obj.com,[':CHAN2:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_UNIT getter
        function val = get.CHAN2_UNIT(obj)
          resp = query(obj.com,':CHAN2:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN2_UNIT setter
        function obj = set.CHAN2_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            fprintf(obj.com,[':CHAN2:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN2_VERN getter
        function val = get.CHAN2_VERN(obj)
          resp = query(obj.com,':CHAN2:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_VERN setter
        function obj = set.CHAN2_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN2:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 3     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN3_BWL getter
        function val = get.CHAN3_BWL(obj)
            resp = query(obj.com,':CHAN3:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN3_BWL setter
       function obj = set.CHAN3_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          fprintf(obj.com,[':CHAN3:BWL ' s ] );
       end
       
       
       % CHAN3_COUP getter
        function val = get.CHAN3_COUP(obj)
            resp = query(obj.com,':CHAN3:COUP?');
            val = deblank(resp);
        end
        
        % CHAN3_COUP setter
        function obj = set.CHAN3_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            fprintf(obj.com,[':CHAN3:COUP ' deblank(val) ] );
        end
 
        % CHAN3_DISP getter
        function val = get.CHAN3_DISP(obj)
          resp = query(obj.com,':CHAN3:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_DISP setter
        function obj = set.CHAN3_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN3:DISP ' cmd{val+1} ] );
        end
        
        % CHAN3_INV getter
        function val = get.CHAN3_INV(obj)
          resp = query(obj.com,':CHAN3:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_INV setter
        function obj = set.CHAN3_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN3:INV ' cmd{val+1} ] );
        end
        
        % CHAN3_OFFS getter
        function val = get.CHAN3_OFFS(obj)
          resp = query(obj.com,':CHAN3:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_OFFS setter
        function obj = set.CHAN3_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            fprintf(obj.com,[':CHAN3:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_RANG getter
        function val = get.CHAN3_RANG(obj)
          resp = query(obj.com,':CHAN3:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_RANG setter
        function obj = set.CHAN3_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            fprintf(obj.com,[':CHAN3:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_TCAL getter
        function val = get.CHAN3_TCAL(obj)
          resp = query(obj.com,':CHAN3:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_TCAL setter
        function obj = set.CHAN3_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            fprintf(obj.com,[':CHAN3:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_SCAL getter
        function val = get.CHAN3_SCAL(obj)
          resp = query(obj.com,':CHAN3:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_SCAL setter
        function obj = set.CHAN3_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            fprintf(obj.com,[':CHAN3:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_PROB getter
        function val = get.CHAN3_PROB(obj)
          resp = query(obj.com,':CHAN3:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_PROB setter
        function obj = set.CHAN3_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            fprintf(obj.com,[':CHAN3:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_UNIT getter
        function val = get.CHAN3_UNIT(obj)
          resp = query(obj.com,':CHAN3:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN3_UNIT setter
        function obj = set.CHAN3_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            fprintf(obj.com,[':CHAN3:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN3_VERN getter
        function val = get.CHAN3_VERN(obj)
          resp = query(obj.com,':CHAN3:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_VERN setter
        function obj = set.CHAN3_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN3:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 4     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        % CHAN4_BWL getter
        function val = get.CHAN4_BWL(obj)
            resp = query(obj.com,':CHAN4:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN4_BWL setter
       function obj = set.CHAN4_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          fprintf(obj.com,[':CHAN4:BWL ' s ] );
       end
       
       
       % CHAN4_COUP getter
        function val = get.CHAN4_COUP(obj)
            resp = query(obj.com,':CHAN4:COUP?');
            val = deblank(resp);
        end
        
        % CHAN4_COUP setter
        function obj = set.CHAN4_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            fprintf(obj.com,[':CHAN4:COUP ' deblank(val) ] );
        end
 
        % CHAN4_DISP getter
        function val = get.CHAN4_DISP(obj)
          resp = query(obj.com,':CHAN4:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_DISP setter
        function obj = set.CHAN4_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN4:DISP ' cmd{val+1} ] );
        end
        
        % CHAN4_INV getter
        function val = get.CHAN4_INV(obj)
          resp = query(obj.com,':CHAN4:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_INV setter
        function obj = set.CHAN4_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN4:INV ' cmd{val+1} ] );
        end
        
        % CHAN4_OFFS getter
        function val = get.CHAN4_OFFS(obj)
          resp = query(obj.com,':CHAN4:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_OFFS setter
        function obj = set.CHAN4_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            fprintf(obj.com,[':CHAN4:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_RANG getter
        function val = get.CHAN4_RANG(obj)
          resp = query(obj.com,':CHAN4:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_RANG setter
        function obj = set.CHAN4_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            fprintf(obj.com,[':CHAN4:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_TCAL getter
        function val = get.CHAN4_TCAL(obj)
          resp = query(obj.com,':CHAN4:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_TCAL setter
        function obj = set.CHAN4_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            fprintf(obj.com,[':CHAN4:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_SCAL getter
        function val = get.CHAN4_SCAL(obj)
          resp = query(obj.com,':CHAN4:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_SCAL setter
        function obj = set.CHAN4_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            fprintf(obj.com,[':CHAN4:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_PROB getter
        function val = get.CHAN4_PROB(obj)
          resp = query(obj.com,':CHAN4:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_PROB setter
        function obj = set.CHAN4_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            fprintf(obj.com,[':CHAN4:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_UNIT getter
        function val = get.CHAN4_UNIT(obj)
          resp = query(obj.com,':CHAN4:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN4_UNIT setter
        function obj = set.CHAN4_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            fprintf(obj.com,[':CHAN4:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN4_VERN getter
        function val = get.CHAN4_VERN(obj)
          resp = query(obj.com,':CHAN4:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_VERN setter
        function obj = set.CHAN4_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            fprintf(obj.com,[':CHAN4:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Assorted      Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        %% Display Commands
        %
        % Display Clear
        function [] = DispClear(obj)
            fprintf(obj.com,':DISP:CLE');
        end
 
        function [val] = get.DISP_TYPE(obj)
          resp = query(obj.com,':DISP:TYPE?');
          val = deblank(resp);
        end
        function [obj] = set.DISP_TYPE(obj,val)
            if ~any(strcmpi(deblank(val),{'VECT','VECTOR','DOTS'}))
                error('INVALID DISP_TYPE');
            end
            fprintf(obj.com,[':DISP:TYPE ' deblank(upper(val)) ] );
        end
        
        % DISP_PERS_TIME getter
        function val = get.DISP_PERS_TIME(obj)
          resp = query(obj.com,':DISP:GRAD:TIME?');
          val = str2double(deblank(resp));
        end
        
        % DISP_PERS_TIME setter
        function obj = set.DISP_PERS_TIME(obj,val)
            if ~isscalar(val)
                error('INVALID DISP_PERS_TIME');
            end
            if val > 10
                cmd = 'INF';
            elseif val < 0.1
                cmd = 'MIN';
            else
                cmd = num2str(val);
            end
            fprintf(obj.com,[':DISP:GRAD:TIME ' cmd ] );
 
        end
        
        % DISP_WAVE_BR getter
        function val = get.DISP_WAVE_BR(obj)
          resp = query(obj.com,':DISP:WBR?');
          val = str2double(deblank(resp));
        end
        
        % DISP_WAVE_BR setter
        function obj = set.DISP_WAVE_BR(obj,val)
            if ~isscalar(val) || val < 0 || val > 100 
                error('INVALID DISP_WAVE_BR');
            end
 
            cmd = num2str(round(val));
 
            fprintf(obj.com,[':DISP:WBR ' cmd ] );
 
        end
        
        % DISP_GRID getter
        function val = get.DISP_GRID(obj)
          resp = query(obj.com,':DISP:GRID?');
          val = deblank(resp);
        end
        
        % DISP_GRID setter
        function obj = set.DISP_GRID(obj,val)
            if ~any(strcmpi(deblank(val),{'FULL','HALF','NONE'}))
                error('INVALID DISP_TYPE');
            end
            fprintf(obj.com,[':DISP:TYPE ' deblank(upper(val)) ] );
 
        end
        
        % DISP_GRID_BR getter
        function val = get.DISP_GRID_BR(obj)
          resp = query(obj.com,':DISP:GBR?');
          val = str2double(deblank(resp));
        end
        
        % DISP_GRID_BR setter
        function obj = set.DISP_GRID_BR(obj,val)
            if ~isscalar(val) || val < 0 || val > 100
                error('INVALID DISP_GRID_BR');
            end
 
            cmd = num2str(round(val));
 
            fprintf(obj.com,[':DISP:GBR ' cmd ] );
 
        end
 
        % T_SCALE getter
        function val = get.T_SCALE(obj)
          resp = query(obj.com,':TIM:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % T_SCALE setter
        function obj = set.T_SCALE(obj,val)
            if ~isscalar(val) || val < 0
                error('INVALID T_SCALE');
            end
 
            cmd = num2str((val),'%10.3e');
 
            fprintf(obj.com,[':TIM:SCAL ' cmd ] );
 
        end
        
        % T_OFFSET getter
        function val = get.T_OFFSET(obj)
          resp = query(obj.com,':TIM:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % T_OFFSET setter
        function obj = set.T_OFFSET(obj,val)
            if ~isscalar(val)
                error('INVALID T_OFFSET');
            end
 
            cmd = num2str((val),'%10.3e');
 
            fprintf(obj.com,[':TIM:OFFS ' cmd ] );
        end
        
        % T_MODE getter
        function val = get.T_MODE(obj)
          resp = query(obj.com,':TIM:MODE?');
          val = deblank(resp);
        end
        
        % T_MODE setter
        function obj = set.T_MODE(obj,val)
            if ~any(strcmpi(deblank(val),{'MAIN','XY','ROLL'})) 
                error('INVALID T_MODE');
            end
            fprintf(obj.com,[':TIM:MODE ' deblank(upper(val)) ] );
 
        end   
 
        % TRIG_HOLDOFF getter
        function val = get.TRIG_HOLDOFF(obj)
          resp = query(obj.com,':TRIG:HOLD?');
          val = str2double(deblank(resp));
        end
        
        % TRIG_HOLDOFF setter
        function obj = set.TRIG_HOLDOFF(obj,val)
            if ~isscalar(val)
                error('INVALID TRIG HOLDOFF');
            end
            fprintf(obj.com,[':TRIG:HOLD '  num2str(val, '%10.3e')] );
        end        
        
        % TRIG_EDGE_CHN getter
        function val = get.TRIG_EDGE_CHN(obj)
          resp = query(obj.com,':TRIG:EDG:SOUR?');
          val = deblank(resp);
        end
        
        % TRIG_EDGE_CHN setter
        %
        % Can accept a char array or scalar between 1 and 4
        function obj = set.TRIG_EDGE_CHN(obj,val)
            if ( ~any(strcmpi(deblank(val),{'CHAN1','CHAN2','CHAN3','CHAN4','AC'})) ...
                    && ( prod(double(val<1)) || prod(double(val>4)) ) )
                
                error('INVALID TRIG_EDGE_CHN');
            end
            
            if isa(val,'char')
                cmd = val;
            else
                cmd =  [ 'CHAN' num2str(round(val),0) ];
            end
            
            fprintf(obj.com,[':TRIG:EDG:SOUR ' deblank(upper(cmd)) ] );
 
        end
        
        % TRIG_EDGE_SLOPE getter
        function val = get.TRIG_EDGE_SLOPE(obj)
          resp = query(obj.com,':TRIG:EDG:SLOP?');
          val = deblank(resp);
        end
        
        % TRIG_EDGE_SLOPE setter
        function obj = set.TRIG_EDGE_SLOPE(obj,val)
            if ~any(strcmpi(deblank(val),{'POS','POSITIVE','NEG','NEGATIVE','RFALI'}))
                error('INVALID TRIG_EDGE_SLOPE');
            end
            
            fprintf(obj.com,[':TRIG:EDG:SLOP ' deblank(upper(val)) ] );
        end
        
        % TRIG_EDGE_LEVEL getter
        function val = get.TRIG_EDGE_LEVEL(obj)
          resp = query(obj.com,':TRIG:EDG:LEV?');
          val = str2double(deblank(resp));
        end
        
        % TRIG_EDGE_LEVEL setter
        function obj = set.TRIG_EDGE_LEVEL(obj,val)
            if ~isscalar(val)
                error('INVALID TRIG_EDGE_LEVEL');
            end
            
            fprintf(obj.com,[':TRIG:EDG:LEV ' num2str(val, '%10.3e') ] );
        end
        
        % TRIG_SWEEP getter
        function val = get.TRIG_SWEEP(obj)
          val = deblank(query(obj.com,':TRIG:SWE?'));
        end
        
        % TRIG_SWEEP setter
        function obj = set.TRIG_SWEEP(obj,val)
            y = {'AUTO','NORM','SING'};
            
            m = strfind(lower(y),lower(val));
            m = ~cellfun(@isempty,m);
            
            if sum(m)==1
                ind = find(m);
                fprintf(obj.com,[':TRIG:SWE ', y{ind}]);
            else 
                error('Invalid input')
            end
        end
        
        
        % TRIG_STATUS getter
        function val = get.TRIG_STATUS(obj)
          resp = query(obj.com,':TRIG:STAT?');
          val = deblank(resp);
        end
        
        % TRIG_STATUS setter
        %function obj = set.TRIG_STATUS(obj,val)
        %end
        
        
        % SRATE getter
        function val = get.SRATE(obj)
          resp = query(obj.com,':ACQ:SRAT?');
          val = str2double(deblank(resp));
        end
        
        % MDEPTH getter
        function val = get.MDEPTH(obj)
            resp = query(obj.com,':ACQuire:MDEPth?');
            if strcmpi(deblank(resp), 'AUTO')
                val = NaN();
            else
                val = str2double(deblank(resp));
            end
        end
        
        % MDEPTH setter
        function obj = set.MDEPTH(obj,val)
            
            if strcmpi(val, 'AUTO')
                fprintf(obj.com, ':ACQuire:MDEP AUTO');
            else
                % Check how many channels are active
                activeChannels = sum([obj.CHAN1_DISP obj.CHAN2_DISP obj.CHAN3_DISP obj.CHAN4_DISP]);
                validMemDepth = [12e3 12e4 12e5 12e6 24e6];
                if activeChannels==3
                    activeChannels = 4;
                end
                validMemDepth = validMemDepth/activeChannels;
                if ismember(val,validMemDepth)
                    str = sprintf(':ACQ:MDEP %d', val);
                    fprintf(obj.com, str);
                else
                    error('Invalid memory depth')
                end
            end
        end

        % WREC_FEND getter
        function val = get.WREC_FEND(obj)
          resp = query(obj.com,':FUNC:WREC:FEND?');
          val = str2double(deblank(resp));
        end
        
        % WREC_FEND setter
        function obj = set.WREC_FEND(obj,val)
            if ~isscalar(val)
                error('INVALID WREC_FEND');
            end
            fprintf(obj.com,[':FUNC:WREC:FEND ' num2str(val, '%d') ] );
        end
        
        % WREC_FMAX getter
        function val = get.WREC_FMAX(obj)
          resp = query(obj.com,':FUNC:WREC:FMAX?');
          val = str2double(deblank(resp));
        end
        
        % WREC_FINT getter
        function val = get.WREC_FINT(obj)
          resp = query(obj.com,':FUNC:WREC:FINT?');
          val = str2double(deblank(resp));
        end
        
        % WREC_FINT setter
        function obj = set.WREC_FINT(obj,val)
            if ~isscalar(val)
                error('INVALID WREC_FINT');
            end
            fprintf(obj.com,[':FUNC:WREC:FINT ' num2str(val, '%10.3e') ] );
        end
        
        % WREC_PROM getter
        function val = get.WREC_PROM(obj)
          resp = query(obj.com,':FUNC:WREC:PROM?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % WREC_PROM setter
        function obj = set.WREC_PROM(obj,val)
            if ~isscalar(val)
                error('INVALID WREC_PROM');
            end
            
            if ischar( val )
                valparse = strcmpi(val,'ON');
            else
                valparse = logical(val);
            end
            
            fprintf(obj.com,[':FUNC:WREC:PROM ' num2str(valparse, '%d') ] );
        end
        
        % WREC_OPER getter
        function val = get.WREC_OPER(obj)
          resp = query(obj.com,':FUNC:WREC:OPER?');
          val = strcmpi(deblank(resp), 'RUN');
        end
        
        % WREC_OPER setter
        function obj = set.WREC_OPER(obj,val)
            if ~isscalar(val)
                error('INVALID WREC_OPER');
            end
            
            if ischar( val )
                cmdidx = strcmpi(val,'ON') + 1;
            else
                cmdidx = logical(val) + 1;
            end
            
            cmd = { 'STOP', 'RUN' };
            fprintf(obj.com,[':FUNC:WREC:OPER ' cmd{cmdidx+1} ] );
        end
        
        
        % WREC_ENAB getter
        function val = get.WREC_ENAB(obj)
          resp = query(obj.com,':FUNC:WREC:ENAB?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % WREC_ENAB setter
        function obj = set.WREC_ENAB(obj,val)
            if ~isscalar(val)
                error('INVALID WREC_ENAB');
            end
            
            if ischar( val )
                valp = strcmpi(val,'ON');
            else
                valp = logical(val);
            end
            fprintf(obj.com,[':FUNC:WREC:ENAB ' num2str(valp,'%d') ] );
        end
        
        
        % WPLAY_FSTART getter
        function val = get.WPLAY_FSTART(obj)
          resp = query(obj.com,':FUNC:WREC:FINT?');
          val = str2double(deblank(resp));
        end
        
        % WPLAY_FSTART setter
        function obj = set.WPLAY_FSTART(obj,val)
            if ~isscalar(val)
                error('INVALID WPLAY_FSTART');
            end
            fprintf(obj.com,[':FUNC:WREC:FINT ' num2str(val, '%10.3e') ] );
        end
        
        % WPLAY_FEND getter
        function val = get.WPLAY_FEND(obj)
          resp = query(obj.com,':FUNC:WREP:FEND?');
          val = str2double(deblank(resp));
        end
        
        % WPLAY_FEND setter
        function obj = set.WPLAY_FEND(obj,val)
            if ~isscalar(val)
                error('INVALID WPLAY_FEND');
            end
            fprintf(obj.com,[':FUNC:WREP:FEND ' num2str(val, '%d') ] );
        end
        
        % WPLAY_FMAX getter
        function val = get.WPLAY_FMAX(obj)
          resp = query(obj.com,':FUNC:WREP:FMAX?');
          val = str2double(deblank(resp));
        end
        
        % WPLAY_FINT getter
        function val = get.WPLAY_FINT(obj)
          resp = query(obj.com,':FUNC:WREP:FINT?');
          val = str2double(deblank(resp));
        end
        
        % WPLAY_FINT setter
        function obj = set.WPLAY_FINT(obj,val)
            if ~isscalar(val)
                error('INVALID WPLAY_FINT');
            end
            fprintf(obj.com,[':FUNC:WREP:FINT ' num2str(val, '%10.3e') ] );
        end
        
        
        % WPLAY_MODE getter
        function val = get.WPLAY_MODE(obj)
          resp = query(obj.com,':FUNC:WREP:MODE?');
          val = deblank(resp);
        end
        
        % WPLAY_MODE setter
        function obj = set.WPLAY_MODE(obj,val)
            if ~any(strcmpi(deblank(val),{'REP','REPEAT','SING','SINGLE'}))
                error('INVALID WPLAY_MODE');
            end
            
            fprintf(obj.com,[':FUNC:WREP:MODE ' deblank(upper(val)) ] );
        end
        
        % WPLAY_DIR getter
        function val = get.WPLAY_DIR(obj)
          resp = query(obj.com,':FUNC:WREP:DIR?');
          val = deblank(resp);
        end
        
        % WPLAY_DIR setter
        function obj = set.WPLAY_DIR(obj,val)
            if ~any(strcmpi(deblank(val),{'FORW','FORWARD','BACK','BACKWARD'}))
                error('INVALID WPLAY_DIR');
            end
            
            fprintf(obj.com,[':FUNC:WREP:DIR ' deblank(upper(val)) ] );
        end
        
        % WPLAY_OPER getter
        function val = get.WPLAY_OPER(obj)
          resp = query(obj.com,':FUNC:WREP:OPER?');
          val = deblank(resp);
        end
        
        % WPLAY_MODE setter
        function obj = set.WPLAY_OPER(obj,val)
            if ~any(strcmpi(deblank(val),{'PLAY','PAUS','PAUSE','STOP'}))
                error('INVALID WPLAY_OPER');
            end
            
            fprintf(obj.com,[':FUNC:WREP:OPER ' deblank(upper(val)) ] );
        end
        
        % WPLAY_FCUR getter
        function val = get.WPLAY_FCUR(obj)
          resp = query(obj.com,':FUNC:WREP:FCUR?');
          val = str2double(deblank(resp));
        end
        
        % WPLAY_FCUR setter
        function obj = set.WPLAY_FCUR(obj,val)
            if ~isscalar(val)
                error('INVALID WPLAY_FCUR');
            end
            fprintf(obj.com,[':FUNC:WREP:FCUR ' num2str(val, '%d') ] );
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Functions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
       % ScreenShot
        %   ColorInvert: logical, Invert RGB Colors (default: true)
        %
        %   Returns a 480x800x3 CData array 
        %
        %   With no return assignment; Draws screenshot to figure
        function [img] = ScreenShot(obj,ColorInvert)
            
            if nargin < 2
                ColorInvert = 1;
            end
            
            txHeader = 11;
            bitHeader = 54;
            pxBytes = (480*800*3);
            
            %Temporarily increase the input buffer size for fetching the
            %bmp
            currentBufferSize = obj.com.InputBufferSize;
            IP = obj.com.RemoteHost
            
            fclose(obj.com)
            obj.com = tcpip(IP, 5555);          
            try
                obj.com.InputBufferSize = 1160000;
                fopen(obj.com);
            catch
                obj.com = [];
                error('Could Not Find Resource');
            end
            
            fprintf(obj.com,'DISP:DATA? [ON, OFF, BMP24]');
            imgdata = fread(obj.com, txHeader + bitHeader + pxBytes);
            
            %Input buffer size should be changed to the old value again
            fclose(obj.com)
            obj.com = tcpip(IP, 5555);             
            try
                obj.com.InputBufferSize = currentBufferSize;
                fopen(obj.com);
            catch
                obj.com = [];
                error('Could Not Find Resource');
            end
            
            % Hard coded pixel indexing for DS1054Z
            % +1 for matlab indexing style
            pxdat = imgdata((txHeader + bitHeader+1):end);
 
        
            %  --- Simple BMP Read ----------------------------------------
            % Elapsed time is 0.075029 seconds.
            B = pxdat(1:3:end);
            G = pxdat(2:3:end);
            R = pxdat(3:3:end);

            % create matlab CData image
            cimg = reshape([R' G' B']./255,[800,480,3]);
            
            img = imrotate(cimg,90);
            %  ------------------------------------------------------------
            
            if ColorInvert
                img = imcomplement(img);
            end
 
            if nargout == 0
                figure;
                imshow(img,'Border','tight');
                axis equal
                
                % Add current date and username to blank space on Rigol
                % Screen shot
                unames = { getenv('USER'), getenv('USERNAME'), getenv('LOGIN'), getenv('LOGNAME') };
                % empty enteries are whitespace 
                ustr = sortrows( char(unames), -1 );
                
                % Set text color for white on black background (default
                % output of DS1054Z) or black on white
                tColor = [ 1 1 1 ] .* ~logical(ColorInvert);
                
                text( 460, 467, [datestr(now) '; ' ustr(1,:) ], 'Interpreter', 'none', 'Color', tColor, 'FontSize',12 )
                img = [];
            end
                
        end
        
        
        % WaveAcquire
        %   CHNIdx: vector of channels to be acquired
        %       CHNIdx = [ 1 2 3 4 ] acquire all 4 channels return in order
        %
        %       CHNIdx = [ 3 1 ] acquire channels 1 and 3 return with
        %       channel 3 in first column and channel 1 in 2nd column
        %
        %   ScreenMemory: logical, acquire from screen data (<= 1200
        %   Samples) or form acquisition memory
        %
        %   
        function [wave,Fs,ts] = WaveAcquire(obj, CHNIdx, ScreenMemory )
            % default to acquiring all active channels
            if nargin < 2
                CHNIdx = obj.ActiveChannels();
            end
         
            % default to acquiring the acquistion memory
            if nargin < 3
                ScreenMemory = 0;
            end
          
            actChannels = obj.ActiveChannels;
            
            if any( ~ismember(CHNIdx,actChannels) ) || ...
                    length(CHNIdx) > sum(actChannels)
            
                error('Some Channels are not active');
            end
            
            mdepth = query(obj.com, ':ACQuire:MDEPth?');
            disp('Memory depth');
            disp(mdepth);
            
            buzzerSetting = query(obj.com, ':SYST:BEEP?');
            disp(buzzerSetting);
             %disable the buzzer
             if buzzerSetting == 1
                fprintf(obj.com,':SYST:BEEP OFF');
             end
            % If the scope is in a non idle mode resume after memory
            % transfer
            resp = query(obj.com,':TRIG:STAT?');
            switch deblank(resp)
                case { 'TD', 'AUTO', 'WAIT' }
                    ReRun = 1;
                    fprintf(obj.com,':STOP');
                    
                % When the DS1054Z is in 'RUN' mode it does not execute the
                % stop command. Typical case of 'RUN' mode is filling the
                % pre-trigger buffer. Wait until the scope transistions 
                % into another mode where it accepts the stop command.
                case 'RUN'
                    while any( strcmpi(deblank(resp), 'RUN' ) )
                        resp = query(obj.com,':TRIG:STAT?');
                        pause(0.01)
                    end
                    
                    fprintf(obj.com,':STOP');
                    
                    if strcmpi( obj.TRIG_SWEEP, 'SING' )
                        ReRun = 0;
                    else
                        ReRun = 1;
                    end

                case 'STOP'
                    ReRun = 0;
            end

            % DS1054Z must be in idle/stop mode to transfer acquistion
            % memory over SCPI/LXI interface
            
            i = 0;
            resp = [];
            while ~strcmpi(deblank(resp), {'STOP'} )
                resp = query(obj.com,':TRIG:STAT?');
%                 pause(0.01)
                i = i + 1;
                
                if i > 30 * 100
                    error('Scope did not end acquisition cycle');
                end
            end
                
            fprintf(obj.com, ':WAV:SOUR CHAN%d', CHNIdx(1));
            fprintf(obj.com, ':WAV:STAR %d', 1);
            fprintf(obj.com, ':WAV:STOP %d', 2);
%             pause(0.1);
            fprintf(obj.com,':WAV:MODE RAW');
            % Set the output memory interface 
            if ScreenMemory
                fprintf(obj.com,':WAVeform:MODE NORM');
            else
                fprintf(obj.com,':WAV:MODE RAW');
            end
            
            % Wave preamble provides the time scale and veritcal scale of
            % ONE channel. However time base is common between channels
            %
            % Hold onto wave preamble response for debuging
            wvs_resp = query(obj.com,':WAV:PRE?');
            wvs = obj.WavStruct(regexp(deblank(wvs_resp), ',', 'split'));

            % Acquistion memory depth is not directly known when in auto
            % mode ... Must infer from sample rate and time scale
            % 12 horizontal divisons
            T_LENGTH = 12*obj.T_SCALE;

            % Parse acquision sample rate
            if ScreenMemory
                % when sampling from screen memory use wave preamble
                Fs = 1/(wvs.xincrement);
                
                [n,~,s] = engunits(Fs);
                disp( [ 'Screen Equivelenet Time Sample Rate: ' num2str(n) ' ' s 'Sa/s'] );
                
                memSamples = min( floor( T_LENGTH * 1/(wvs.xincrement)), 1200 ); 
            else
                Fs = round(obj.SRATE);
                if isnan(obj.MDEPTH)
                    memSamples = min( floor( T_LENGTH * Fs ), 24e6 );
                else
                    memSamples = obj.MDEPTH;
                end
            end
 
            % The DS1054Z does not always return a correct preamble
            % sometimes the xincrement field is orders of magnitude in
            % error
            if Fs ~= round( 1/(wvs.xincrement) )
                [n,~,s] = engunits(1/(wvs.xincrement));
                disp( [ 'Preamble Sample Rate: ' num2str(n) ' ' s 'Sa/s'] );
                
                [n,~,s] = engunits(obj.SRATE);
                disp( [ 'ACQ Sample Rate: '  num2str(n) ' ' s 'Sa/s'] );
                
                disp('buggy scope..., perhaps bad preamble?')
                disp(wvs)
                disp('Preamble return string:')
                disp(wvs_resp)
            end
            

            
            % Pre-allocate wave sample memory
            wave = zeros(memSamples,length(CHNIdx));
            
            % Pre-allocate wave preamble struct array
            wPre = repmat(wvs,1,length(CHNIdx));

            for j = 1:length(CHNIdx)
                CHN = CHNIdx(j);
                
                % select channel (CHN) for transfer
                fprintf(obj.com,sprintf(':WAV:SOUR CHAN%d', CHN));
                
                % request channel wave preamble
                resp = query(obj.com,':WAV:PRE?');
                wPre(j) = obj.WavStruct(regexp(deblank(resp), ',', 'split'));
 
                % DS1054Z Does not like to read more than somewhere between 
                % 1 MSample to 200 kSamples at a time
                % Iterate reading up to 200 kSample memory blocks
                blkSize = 200e3; %round( 500E3 / obj.NumActiveChannels() );
                
%                 fprintf( '\nTransfering Channel %d\n', CHN );
                
                for i = 1:ceil(24E6/blkSize)
                    startidx = 1 + (i-1)*blkSize;
                    stopidx = min( i*blkSize, memSamples );

                    % set start and stop indices for current memory block
                    fprintf(obj.com,sprintf(':WAV:STAR %d', startidx));
                    fprintf(obj.com,sprintf(':WAV:STOP %d', stopidx));
                    disp('Set Start and stop');
                    % Query for memory block
                    bufSize = min(stopidx-startidx+1, memSamples) + 12;
                    fprintf(obj.com,':WAV:DATA?');
                    buf = fread(obj.com,bufSize);
%                     buf = query(obj.com,':WAV:DATA?');
                    len = stopidx - startidx + 1;
                    
                    TMC_HDR = buf(1:11);
                    TMC_dlen = str2double(char(TMC_HDR(3:end).'));
                    
                    if TMC_dlen ~= len
                        disp( 'Scope did not return correct data length')
                    end

                    if length(buf) < ( len + 11 )
                        disp('Insufficent data samples returned, perhaps bad preamble?')
                        disp(wvs)
                        disp('Preamble return string:')
                        disp(wvs_resp)
                        error('Did not return data')
                    end
                    
                    % Assign wave data index past TMC header
                    wave(startidx:stopidx, j) = buf(12:(12+len-1));
                    
                    if mod(i,10) == 1
                        fprintf('\n')
                    end
%                     
%                     % print percent complete
                    fprintf( '%3d%% ', round( stopidx/memSamples *100) );

                    if( stopidx >= memSamples )
                        break;
                    end
                end
 
            end

            fprintf('\n')
            
             if buzzerSetting == 1
                fprintf(obj.com,':SYST:BEEP ON');
             end
             
            if ReRun            
                fprintf(obj.com,':RUN');
            end
            
            
            if nargout >= 1
                % Convert binary ADC output to floating point measurement
                for j = 1:length(CHNIdx)
                    wave(:,j) = (wave(:,j) - wPre(j).yreference - wPre(j).yorigin) .* wPre(j).yincrement;
                end
            else
                wave=[];
                disp('No assignment made... saved lots of data points from scrolling')
            end
            
            if nargout == 3
                % When Trigger offset is set to 0 s, sample memory spans -6
                % graticules to +6 graticules.
                t0 = -6*obj.T_SCALE + obj.T_OFFSET;
                ts = t0:1/Fs:(t0 +(memSamples-1)/Fs);
                ts = ts';
            end

        end
        
        function [wave,Fs,ts] = InternalWaveAcquire(obj, CHNIdx, ScreenMemory )
            % default to acquiring all active channels
            if nargin < 2
                CHNIdx = obj.ActiveChannels();
            end
         
            % default to acquiring the acquistion memory
            if nargin < 3
                ScreenMemory = 0;
            end
          
            actChannels = obj.ActiveChannels;
            
            if any( ~ismember(CHNIdx,actChannels) ) || ...
                    length(CHNIdx) > sum(actChannels)
            
                error('Some Channels are not active');
            end

            % If the scope is in a non idle mode resume after memory
            % transfer
            resp = query(obj.com,':TRIG:STAT?');
            switch deblank(resp)
                case { 'TD', 'AUTO', 'WAIT' }
                    ReRun = 1;
                    fprintf(obj.com,':STOP');
                    
                % When the DS1054Z is in 'RUN' mode it does not execute the
                % stop command. Typical case of 'RUN' mode is filling the
                % pre-trigger buffer. Wait until the scope transistions 
                % into another mode where it accepts the stop command.
                case 'RUN'
                    while any( strcmpi(deblank(resp), 'RUN' ) )
                        resp = query(obj.com,':TRIG:STAT?');
                        pause(0.01)
                    end
                    
                    fprintf(obj.com,':STOP');
                    
                    if strcmpi( obj.TRIG_SWEEP, 'SING' )
                        ReRun = 0;
                    else
                        ReRun = 1;
                    end

                case 'STOP'
                    ReRun = 0;
            end

            % DS1054Z must be in idle/stop mode to transfer acquistion
            % memory over SCPI/LXI interface
            
            i = 0;
            resp = [];
            while ~strcmpi(deblank(resp), {'STOP'} )
                resp = query(obj.com,':TRIG:STAT?');
%                 pause(0.01)
                i = i + 1;
                
                if i > 30 * 100
                    error('Scope did not end acquisition cycle');
                end
            end
                
            fprintf(obj.com, ':WAV:SOUR CHAN%d', CHNIdx(1));
            fprintf(obj.com, ':WAV:STAR %d', 1);
            fprintf(obj.com, ':WAV:STOP %d', 2);
%             pause(0.1);

            % Set the output memory interface 
            if ScreenMemory
                fprintf(obj.com,':WAVeform:MODE NORM');
            else
                fprintf(obj.com,':WAV:MODE RAW');
            end
          %  fprintf(obj.com,':WAV:MODE RAW');
          %  disp(query(obj.com,':WAV:MODE?'));
            % Wave preamble provides the time scale and vertical scale of
            % ONE channel. However time base is common between channels
            %
            % Hold onto wave preamble response for debuging
            wvs_resp = query(obj.com,':WAV:PRE?');
            wvs = obj.WavStruct(regexp(deblank(wvs_resp), ',', 'split'));

            % Acquistion memory depth is not directly known when in auto
            % mode ... Must infer from sample rate and time scale
            % 12 horizontal divisons
            T_LENGTH = 12*obj.T_SCALE;

            % Parse acquision sample rate
            if ScreenMemory
                % when sampling from screen memory use wave preamble
                Fs = 1/(wvs.xincrement);
                
                [n,~,s] = engunits(Fs);
                disp( [ 'Screen Equivelenet Time Sample Rate: ' num2str(n) ' ' s 'Sa/s'] );
                
                memSamples = min( floor( T_LENGTH * 1/(wvs.xincrement)), 1200 ); 
            else
                Fs = round(obj.SRATE);
                if isnan(obj.MDEPTH)
                    memSamples = min( floor( T_LENGTH * Fs ), 24e6 );
                else
                    memSamples = obj.MDEPTH;
                end
            end
 
            % The DS1054Z does not always return a correct preamble
            % sometimes the xincrement field is orders of magnitude in
            % error
            if Fs ~= round( 1/(wvs.xincrement) )
                [n,~,s] = engunits(1/(wvs.xincrement));
                disp( [ 'Preamble Sample Rate: ' num2str(n) ' ' s 'Sa/s'] );
                
                [n,~,s] = engunits(obj.SRATE);
                disp( [ 'ACQ Sample Rate: '  num2str(n) ' ' s 'Sa/s'] );
                
                disp('buggy scope..., perhaps bad preamble?')
                disp(wvs)
                disp('Preamble return string:')
                disp(wvs_resp)
            end
            

            
            % Pre-allocate wave sample memory
            wave = zeros(memSamples,length(CHNIdx));
            
            % Pre-allocate wave preamble struct array
            wPre = repmat(wvs,1,length(CHNIdx));

            for j = 1:length(CHNIdx)
                CHN = CHNIdx(j);
                
                % select channel (CHN) for transfer
                fprintf(obj.com,sprintf(':WAV:SOUR CHAN%d', CHN));
                
                % request channel wave preamble
                resp = query(obj.com,':WAV:PRE?');
                wPre(j) = obj.WavStruct(regexp(deblank(resp), ',', 'split'));
 
                % DS1054Z Does not like to read more than somewhere between 
                % 1 MSample to 200 kSamples at a time
                % Iterate reading up to 200 kSample memory blocks
                blkSize = 200e3; %round( 500E3 / obj.NumActiveChannels() );
                
%                 fprintf( '\nTransfering Channel %d\n', CHN );
                
                for i = 1:ceil(24E6/blkSize)
                    startidx = 1 + (i-1)*blkSize;
                    stopidx = min( i*blkSize, memSamples );

                    % set start and stop indices for current memory block
                    fprintf(obj.com,sprintf(':WAV:STAR %d', startidx));
                    fprintf(obj.com,sprintf(':WAV:STOP %d', stopidx));
                    disp('Set Start and stop');
                    % Query for memory block
                    bufSize = min(stopidx-startidx+1, memSamples) + 12;
                    fprintf(obj.com,':WAV:DATA?');
                    buf = fread(obj.com,bufSize);
%                     buf = query(obj.com,':WAV:DATA?');
                    len = stopidx - startidx + 1;
                    
                    TMC_HDR = buf(1:11);
                    TMC_dlen = str2double(char(TMC_HDR(3:end).'));
                    
                    if TMC_dlen ~= len
                        disp( 'Scope did not return correct data length')
                    end

                    if length(buf) < ( len + 11 )
                        disp('Insufficent data samples returned, perhaps bad preamble?')
                        disp(wvs)
                        disp('Preamble return string:')
                        disp(wvs_resp)
                        error('Did not return data')
                    end
                    
                    % Assign wave data index past TMC header
                    wave(startidx:stopidx, j) = buf(12:(12+len-1));
                    
                    if mod(i,10) == 1
                        fprintf('\n')
                    end
%                     
%                     % print percent complete
                    fprintf( '%3d%% ', round( stopidx/memSamples *100) );

                    if( stopidx >= memSamples )
                        break;
                    end
                end
 
            end

            fprintf('\n')
            
            if ReRun            
                fprintf(obj.com,':RUN');
            end
            
            
            if nargout >= 1
                % Convert binary ADC output to floating point measurement
                for j = 1:length(CHNIdx)
                    wave(:,j) = (wave(:,j) - wPre(j).yreference - wPre(j).yorigin) .* wPre(j).yincrement;
                end
            else
                wave=[];
                disp('No assignment made... saved lots of data points from scrolling')
            end
            
            if nargout == 3
                % When Trigger offset is set to 0 s, sample memory spans -6
                % graticules to +6 graticules.
                t0 = -6*obj.T_SCALE + obj.T_OFFSET;
                ts = t0:1/Fs:(t0 +(memSamples-1)/Fs);
                ts = ts';
            end

        end
        
        
        % Set trigger delay to 1st graticule on left hand side
        function [] = LeftTrigger(obj)
            obj.T_OFFSET = 5 * obj.T_SCALE;
        end
        
        % WavReplay
        %   returns:
        %       wave    ( m by n by j ) m: sample buffer length
        %                               n: frame count
        %                               j: channel count
        function [wave,Fs,ts] = WavReplay(obj, CHNIdx, ScreenMemory )
            
            if ~obj.WREC_ENAB
                error('Wave recording not enabled')
            end
            
            % default to acquiring all active channels
            if nargin < 2
                CHNIdx = obj.ActiveChannels();
            end
            
            % default to acquiring the acquistion memory
            if nargin < 3
                ScreenMemory = 0;
            end
            
            if any( ~ismember(CHNIdx,obj.ActiveChannels()) ) || ...
                    length(CHNIdx) > obj.NumActiveChannels
                error('Some Channels are not active');
            end
            
            % Set the output memory interface 
            if ScreenMemory
                fprintf(obj.com,':WAV:MODE NORM');
            else
                fprintf(obj.com,':WAV:MODE RAW');
            end
            
            % Wave preamble provides the time scale and veritcal scale of
            % ONE channel. However time base is common between channels
            %
            % Hold onto wave preamble response for debuging
            wvs_resp = query(obj.com,':WAV:PRE?');
            
            wvs = obj.WavStruct(regexp(deblank(wvs_resp), ',', 'split'));

            % Acquistion memory depth is not directly known when in auto
            % mode ... Must infer from sample rate and time scale
            % 12 horizontal divisons
            T_LENGTH = 12*obj.T_SCALE;
 
            % Parse acquision sample rate
            if ScreenMemory
                % when sampling from screen memory use wave preamble
                Fs = 1/(wvs.xincrement);
                
                [n,~,s] = engunits(Fs);
                disp( [ 'Screen Equivelenet Time Sample Rate: ' num2str(n) ' ' s 'Sa/s'] );
                
                memSamples = min( floor( T_LENGTH * 1/(wvs.xincrement)), 1200 ); 
            else
                Fs = round(obj.SRATE);
                if isnan(obj.MDEPTH)
                    memSamples = min( floor( T_LENGTH * Fs ), 24e6 );
                else
                    memSamples = obj.MDEPTH;
                end
            end
            
            frameCount = obj.WPLAY_FEND;
            
            wave = NaN(memSamples,frameCount,length(CHNIdx));
            
            obj.WPLAY_OPER = 'STOP';
            
            for frame = 1:frameCount
                obj.WPLAY_FCUR = frame;
                
                w = obj.WaveAcquire(CHNIdx, ScreenMemory );
                
                wave(:,frame,:) = w;
            end
            
            if nargout == 3
                % When Trigger offset is set to 0 s, sample memory spans -6
                % graticules to +6 graticules.
                t0 = -6*obj.T_SCALE + obj.T_OFFSET;
                ts = t0:1/Fs:(t0 +(memSamples-1)/Fs);
                ts = ts';
            end
            
        end
        
        function saveObj = saveobj(obj)
            saveObj = struct(obj);
            saveObj.TimeStamp = datestr(now);
        end
        
        function Run(obj)
            fprintf(obj.com,':RUN');
        end
        
        function Stop(obj)
            fprintf(obj.com,':STOP');
        end
        
        function Single(obj)
            fprintf(obj.com,':SING')
        end
    end
    
    methods ( Access = private )
        function wavStruct = WavStruct(obj, wavPreamble)
            
            fields = {'format';  'type';  'points';  'count';  'xincrement'; ...
                'xorigin';  'xreference';  'yincrement';  'yorigin';  'yreference' };
            
            val = str2double(wavPreamble);
            cellVal = num2cell(val');
            
            wavStruct = cell2struct(cellVal, fields, 1 );
        end
        
        function n = NumActiveChannels(obj)
%             n = sum( [ obj.CHAN1_DISP obj.CHAN2_DISP obj.CHAN3_DISP obj.CHAN4_DISP ] );
            idx = [ obj.CHAN1_DISP obj.CHAN2_DISP obj.CHAN3_DISP obj.CHAN4_DISP ];
            n=sum(idx);
        end
        
        function ActChan = ActiveChannels(obj)
            idx = [ obj.CHAN1_DISP obj.CHAN2_DISP obj.CHAN3_DISP obj.CHAN4_DISP ];
            temp = 1:4;
            ActChan = temp(idx);
        end
        
        % With one (string) input, return string
        % With two inputs (string + integer), return a vector 
%         function resp = query(obj.com,str,varargin)
%             fprintf(obj.com.vCom, str);
%             if ~isempty(varargin) && length(varargin)==1 
%                 if round(varargin{1})==varargin{1} % Should be integer
%                     resp = fread(obj.vCom, varargin{1});
%                 else
%                     error('Length should be an integer number')
%                 end
%             else
%                 resp = fgetl(obj.vCom);
%             end
%         end
        
%         function StrWrite(obj,str)
%             fprintf(obj.com.vCom, str);
%         end
    end
    
    methods (Static = true)
        % Load DS1054Z obj from file, ldat is a struct with the same
        % properties as a DS1054Z obj.
        %
        % TODO: Need to decide if loading updates the scope to previous
        % settings or provides a cached obj for reference
        function obj = loadobj(ldat)
            disp(ldat);  
%           floadNames = { 'CHAN1_BWL', 'CHAN1_COUP', 'CHAN1_DISP', 'CHAN1_INV', 'CHAN1_OFFS', ...
%               '', 'CHAN1_TCAL', 'CHAN1_SCAL', 'CHAN1_PROB', 'CHAN1_UNIT', 'CHAN1_VERN', ...
%               'CHAN2_BWL', 'CHAN2_COUP', 'CHAN2_DISP', 'CHAN2_INV', 'CHAN2_OFFS', '', ...
%               'CHAN2_TCAL', 'CHAN2_SCAL', 'CHAN2_PROB', 'CHAN2_UNIT', 'CHAN2_VERN', 'CHAN3_BWL', ...
%               'CHAN3_COUP', 'CHAN3_DISP', 'CHAN3_INV', 'CHAN3_OFFS', '', 'CHAN3_TCAL', ...
%               'CHAN3_SCAL', 'CHAN3_PROB', 'CHAN3_UNIT', 'CHAN3_VERN', 'CHAN4_BWL', 'CHAN4_COUP', ...
%               'CHAN4_DISP', 'CHAN4_INV', 'CHAN4_OFFS', '', 'CHAN4_TCAL', 'CHAN4_SCAL', ...
%               'CHAN4_PROB', 'CHAN4_UNIT', 'CHAN4_VERN', 'DISP_TYPE', 'DISP_PERS_TIME', 'DISP_WAVE_BR', ...
%               'DISP_GRID', 'DISP_GRID_BR', 'T_SCALE', 'T_OFFSET', 'T_MODE', 'TRIG_HOLD_OFF', ...
%               'TRIG_EDGE_CHN', 'TRIG_EDGE_SLOPE', 'TRIG_EDGE_LEVEL', 'TRIG_SWEEP', };
%           
%           propnames = fieldnames(ldat);
%           
            obj =  DS1054Z(ldat.RSRC_ADDR);
          
%           for i = 1:length(propnames)
%               if ismember( propnames{i}, floadNames )
%                 obj.(propnames{i}) = ldat.(propnames{i});
%               end
%           end
        end
    end
    
end
