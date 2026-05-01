function plot_shift(varargin)

% //////////////// Corey Gravelle (c) October 2010 ///////////////////
%
% plot_shift('figure',[],'axes',[],'ex',[],'toggle',[],'flip',[],'objs',[])
% -------------------------------------------------------------------
% INPUTS:   figure = handle of desired figure;
%           axes = handle of desired axes (must be child of hfig)
%           ex = desired example (hfig and haxes must be empty)
%           toggle = switching features on or off for a graph
%           flip = flips navigation vertically or horizontally
%           
% -------------------------------------------------------------------
% EXAMPLES: plot_shift('ex','plot1');
%           plot_shift('ex','plot2');
%           plot_shift('ex','plot3');
% -------------------------------------------------------------------
% USE:      click and drag off of object to pan
%           click and drag object to move it
%           right-click to show/hide titles
%           right-click to fit all plots in window
%           shift-click to create zoom rectangle
%           double-click to recenter
%           mouse scroll wheel to zoom in/out
% -------------------------------------------------------------------
% FEATURES TO ADD (eventually...):
%           ability to select and move multiple lines ('group')
%           highlighting selected group
%           optional legend, and selecting on plot from it
%           plot scaling to account for very large plot lag
% -------------------------------------------------------------------
% Similar files: uilineshift.m, navigate.m, scroll_wheel.m, pan.m
% @:  http://blogs.mathworks.com/pick/2009/06/12/uilineshift/
% @:  http://www.mathworks.com/matlabcentral/fileexchange/28998-navigate-m
% @:  run([docroot '/techdoc/ref/examples/scroll_wheel']);
% @:  open pan;
%
% /////////////////////////////////////////////////////////////////////



global hfig haxes s group ptrloc axpos ptrval valperpix dont ax p
persistent curr_s curr_obj
close all;

p = inputParser;
p.addParamValue('figure', [], @(x)isnumeric(x));    %input figure handle
p.addParamValue('axes', [], @(x)isnumeric(x));      %input axes handle
p.addParamValue('ex', [], @(x)ischar(x));       %desired example
p.addParamValue('toggle','on',@(x)ischar(x));       %toggles on/off
p.addParamValue('flip','v',@(x)ischar(x));
p.addParamValue('objs',[],@(x)isstruct(x));
p.parse(varargin{:});
hfig = p.Results.figure;
haxes = p.Results.axes;
ex = p.Results.ex;
toggle = p.Results.toggle;
flip = p.Results.flip;
objs = p.Results.objs;

% Create figure and axes handle, if necessary
if isempty(hfig)
   hfig = figure('Name','Plot Navigation Demo',...
       'Toolbar','none','Menu','none','NumberTitle','off');...
   vsplit = uiextras.VBox('Parent',hfig);
   panel = uipanel('Parent',vsplit);
%    hG = uicontrol('Parent',panel,'Position',[200 3 100 20],...
%        'String','group','Callback',@group_Callback);
   haxes = axes('Parent',panel,'units','normalized','Position',[0 0 1 1]);
   grid on;

end
if isempty(haxes)
    haxes = axes;
    ax=findobj(gcf,'type','axes');
else
    ax = haxes;
end

% used for viewing current point location and value:
% hText = uicontrol('Parent',panel,'Style','text','String','go...',...
%        'Position',[3 3 120 40],'Visible','on');

% EXAMPLES:
if ~isempty(ex)
    switch ex
       case 'plot1'
            x = [0:.1:40];
            y = 4.*cos(x)./(x+2);
            h = plot(x,y);
       case 'plot2'
            hold on
            a=hanning(20);  % filter
            imp=round(rand(10,1)*100);
            rest=round(rand(10,1)*100);
            x=[];
            for i=1:length(imp)
                tp=[zeros(rest(i),1); ones(imp(i),1)  ];
                x(end+1:end+length(tp),1)=tp;
            end
            x=x+(rand(size(x,1),1)./3);
            y=conv(x,a);

            obj1 = ((x)-mean(x))./std(x);
            obj2 = ((y)-mean(y))./std(y);
            plot( 1:length(x), obj1, 'color','k', 'linewidth',1.5);
            plot( 1:length(y), obj2, 'color','r', 'linewidth',1.5);
            title('shift traces');
            
            set(haxes,'Units','normalized');
            clear x
       case 'plot3'
            a=hanning(20);  % filter
            for g = 1:2:10
                imp=round(rand(10,1)*100);
                rest=round(rand(10,1)*100);
                x=[];
                for i=1:length(imp)
                    tp=[zeros(rest(i),1); ones(imp(i),1)  ];
                    x(end+1:end+length(tp),1)=tp;
                end
                x=x+(rand(size(x,1),1)./3);
                y=conv(x,a)+300*g;
                x=x;
                %Creating sample input objects:
                ob(g) = struct('data',{((x)-mean(x))./std(x)},...
                    'name',{['obj',num2str(g)]});
                ob(g+1) = struct('data',{((y)-mean(y))./std(y)},...
                    'name',{['obj',num2str(g+1)]});
            end
            
            clear x
            plot_shift('objs',ob);
            set(hfig,'Position',[100 100 1000 800]);

            set(haxes,'Units','normalized');

       case 'image'
            mona = imread('mona.jpg');
            imshow(mona);
    end
end

% Initializing variables:
axlims = axis;
group = [];
curr_obj = [];
curr_s = [];
dont= 0;
namecall = 'Hide';
hidenames = 0;
panPoint1 = [];

% load objects with 'data' and 'name' properties; give color
if ~isempty(objs)
    colormat_dk = load('colormat_dk.mat');
    colormat_dk = colormat_dk.colormat;
    for oind = 1:length(objs)
        if ~isfield(objs(oind),'color')
            ocol = colormat_dk(oind,:);
        else ocol = objs(oind).color;
        end
        ol = length(objs(oind).data);
        curax = axis;
        o = line( 1:ol, objs(oind).data+curax(4),'color',ocol, 'linewidth',1.5);
        odata = get(o,'UserData');
        odata.name = objs(oind).name;
        set(o,'UserData',odata);
    end

end

% find all plotted line objects
for j=1:length(ax)
    p=findobj(ax(j),'type','line');
    for k = 1:length(p)
        s=get(p(k),'userdata');
        s.xorig=get(p(k),'xdata');
        s.yorig=get(p(k),'ydata');
        s.grp=0;
        s.xo=[];
        if ~isfield(s,'name')
            s.name='filler';
        end
        yp = get(p(k),'YData');
        xd = get(p(k),'XData');
        ocol = get(p(k),'Color');
        %@NOTE: why are names duplicated??? also, Plot only within axis?
        s.hname=text((min(xd)-50), (max(yp)*.5),s.name,...
            'FontSize',8,'Color',ocol,'Visible','off');
        set(p(k),'UserData',s);
    end
end

zoomAll_Callback(0,0);
cmenu; %set contextmenu

% set windowbutton functions for clicking/dragging/etc.
if strcmp(toggle, 'on')   %@NOTE: put previous functions back? would need 
                          %to save them as another input...
    set(hfig,'WindowScrollWheelFcn',@figScroll,...
        'WindowButtonMotionFcn',@mouseMove1,'WindowButtonDownFcn',@clickFcn,...
        'WindowButtonUpFcn',@releaseFcn);
else
    set(hfig,'WindowScrollWheelFcn',@nothin,...
        'WindowButtonMotionFcn',@nothin,'WindowButtonDownFcn',@nothin,...
        'WindowButtonUpFcn',@nothin);
    return;
end


%% NESTED FUNCTIONS:

% filler for toggling 'navigate' off
function nothin(source,eventdata)

end

% gets current mouse point., without plot-shifting qualities: 
function mouseMove1(source,event)
    
    %PANNING FUNCTION:
    origunits = get(haxes,'Units');
    set(haxes,'Units','pixels');
    ptrloc=get(source,'CurrentPoint');
    axpos=get(haxes,'Position');

    inAxes=(ptrloc(1,1)>=axpos(1)) && ...
        (ptrloc(1,1)<axpos(1)+axpos(3)) && ...
        (ptrloc(1,2)>axpos(2)) && ...
        (ptrloc(1,2)<axpos(2)+axpos(4));
    if inAxes
        ptrval=get(haxes,'CurrentPoint');
        ptrval=[ptrval(1,1),ptrval(1,2)];

        if ~isempty(panPoint1)
    %             panPoint2 = ptrval;
            panPoint2 = ptrloc;
            panPoint2 = [panPoint2(1,1),panPoint2(1,2)];
            panvect = valperpix.*(panPoint2-panPoint1);
            switch flip
                case 'none'
                    axlimstemp = [axlims(1)-panvect(1),...
                        axlims(2)-panvect(1),axlims(3)+panvect(2),...
                        axlims(4)+panvect(2)];
                case 'v'
                    axlimstemp = [axlims(1)-panvect(1),...
                        axlims(2)-panvect(1),axlims(3)-panvect(2),...
                        axlims(4)-panvect(2)];
                case 'h'
                    axlimstemp = [axlims(1)+panvect(1),...
                        axlims(2)+panvect(1),axlims(3)+panvect(2),...
                        axlims(4)+panvect(2)];
            end
            axis(axlimstemp);
        end
        
        if ~isempty(ex)
            digits(3)
            ptr2num = (ptrval(2)*1);
            coordsStr=['ptrloc:(',num2str(ptrloc(1,1)),',',...
            num2str(ptrloc(1,2)),') ptrval:(',...
            num2str(round(ptrval(1))),...
            ',',num2str(ptr2num),')'];
%             set(hText,'String',coordsStr);
        end
    end
    set(haxes,'Units',origunits);
    
end
% gets current mouse point., with plot-shifting qualities: 
function mouseMove2(source,eventdata)

% from #7 near end of...
% http://msenux.redwoods.edu/Math4Textbook/Programming/NestedFunctions.pdf

    mouseMove1(source,eventdata);  
    origaxis = axis;
    origunits = get(haxes,'Units');
    set(haxes,'Units','pixels');
    ptrloc = get(source,'CurrentPoint');
    curr_pt = get(gca,'CurrentPoint');
    this=gco;
    s=get(this,'UserData');
     
    inAxes=(ptrloc(1,1)>=axpos(1)) && ...
        (ptrloc(1,1)<axpos(1)+axpos(3)) && ...
        (ptrloc(1,2)>axpos(2)) && ...
        (ptrloc(1,2)<axpos(2)+axpos(4));
    
    if inAxes

    % /////////////////// now, shifting properties : ///////////////////
    

        if~isempty(s)
            if isempty(s.xo)%reference values XY
                s.x=get(this,'xdata');
                s.y=get(this,'ydata');
                s.xo=curr_pt;
                set(this,'UserData',s);
            else

                set(this,'YData',s.y - s.xo(1, 2)  +curr_pt(1, 2)  );%update XY
                set(this,'xData',s.x - s.xo(1, 1)  +curr_pt(1, 1));
                s.x=get(this,'xdata');
                s.y=get(this,'ydata');
                s.xo=curr_pt;
                set(this,'UserData',s);


                if length(group)>1
                    for g = 2: length(group)
                        s = get(group(g),'UserData');
                        set(group(g),'YData',s.y - s.xo(1, 2)  +curr_pt(1, 2)  );%update XY
                        set(group(g),'XData',s.x - s.xo(1, 1)  +curr_pt(1, 1));
                        s.x=get(group(g),'Xdata');
                        s.y=get(group(g),'Ydata');
                        s.xo=curr_pt;
                        set(group(g),'UserData',s);
                    end
                end
            end
        end

        if ~isempty(ex)
            coordsStr=['ptrloc:(',num2str(ptrloc(1,1)),',',...
            num2str(ptrloc(1,2)),') axpos:(',...
            num2str(round(axpos(1))),',',num2str(round(axpos(2))),',',...
            num2str(round(axpos(3))),',',num2str(round(axpos(4))),')'];
%             set(hText,'String',coordsStr);
        end
       
    end
    
    set(haxes,'Units',origunits);
    axis(origaxis)

end

% Called at click of mouse:
function clickFcn(source,varargin)

    %types: 'normal', 'alt' = right-click, 'extend' =shift+click
    sel_type = get(gcf,'selectiontype');
    
    axpos=get(haxes,'Position');
    curr_obj = gco;
    curr_s = get(curr_obj,'UserData');
    origunits = get(haxes,'Units');
    set(haxes,'Units','pixels');
    axlims = axis;

    switch sel_type
        
    %PLAIN CLICK ================================================
    case 'normal'  

        %Clicked on a (line) object ~ ADD TO SELECTED GROUP:
        if ~isempty(curr_s) 

            %New object selected
            if ~(curr_s.grp)
                groupclear;
                group(1) = curr_obj; 
                groupupdate;
                
            %Member of current group selected    
            else
                groupupdate;
            end
            
            curr_s.grp= 1;
            curx = get(curr_obj,'XData');
            cury = get(curr_obj,'YData');
            set(curr_obj,'UserData',curr_s);
            
            %Hide title while moving:
            s=get(curr_obj,'userdata');
            yp = get(curr_obj,'YData');
            xd = get(curr_obj,'XData');
            ocol = get(curr_obj,'Color');
            set(s.hname,'Visible','off');
            set(curr_obj,'UserData',s);
            set(curr_obj,'UserData',s,'ButtonDownFcn',{@clickFcn});
            
%             hi = line(curx,cury,'LineWidth',10,'Color','y');
%             set(hi,'UserData','highlighted');

        else    %Did not click on an object ~ PAN:
            axpix = get(hfig,'Position');
            panPoint1 = ptrloc;
            panPoint1 = [panPoint1(1,1),panPoint1(1,2)];
            axdim = [axlims(2)-axlims(1),axlims(4)-axlims(3)];     %width,height
            %ratio of axis value/position movement:
            valperpix = [axdim(1)/axpix(3),axdim(2)/axpix(4)];

        end
        

        

    % NOTE4 (see bottom)

    %SHIFT-CLICK ==============================================
    case 'extend'       %zoom rectangle

        axPoint1 = ptrval;
        zr = rbbox([ptrloc,0,0]);
        axPoint2 = ptrval;
%         newAxis = [zr(1),zr(1)+zr(3),zr(2),zr(2)+zr(4)];
        
        cwh = [axlims(2)-axlims(1),axlims(4)-axlims(3)];
        axll = [min(axPoint1(1),axPoint2(1)),...
            min(axPoint1(2),axPoint2(2))];
        axwh = [abs(axPoint1(1)-axPoint2(1)),...
            abs(axPoint1(2)-axPoint2(2))];
        if (axwh(1)>cwh(1)/50) && (axwh(2)>cwh(2)/50)   %(accident chk)
            axlims = [axll(1),axwh(1)+axll(1),axll(2),axwh(2)+axll(2)];
            axis(axlims);
        end 
        
    %DOUBLE-CLICK===============================================
    case 'open'
          
        axsize = [abs(axlims(2)-axlims(1)),abs(axlims(4)-axlims(3))];
        axlims =  [ptrval(1)-axsize(1)/2,ptrval(1)+axsize(1)/2,...
           ptrval(2)-axsize(2)/2,ptrval(2)+axsize(2)/2];
        axis(axlims);
%         groupclear;

    end
    
    %Return axes units to original
    set(haxes,'Units',origunits);
    
    if ~isempty(curr_s)
        set(gcf,'WindowButtonMotionFcn',@mouseMove2);%WBMF w/ shift
    else
        set(gcf,'WindowButtonMotionFcn',@mouseMove1);%WBMF w/o shift
    end
end

% Called when click is released:
function releaseFcn(source,event)

    UpdateFigshift(0)
    
    if ~isempty(panPoint1)
        origunits = get(haxes,'Units');
        set(haxes,'Units','pixels');
%         axlims = axis;
        panPoint2 = ptrloc;
        panPoint2 = [panPoint2(1,1),panPoint2(1,2)];
        panvect = valperpix.*(panPoint2-panPoint1);
        switch flip
            case 'none'
                axlims = [axlims(1)-panvect(1),...
                    axlims(2)-panvect(1),axlims(3)+panvect(2),...
                    axlims(4)+panvect(2)];
            case 'v'
                axlims = [axlims(1)-panvect(1),...
                    axlims(2)-panvect(1),axlims(3)-panvect(2),...
                    axlims(4)-panvect(2)];
            case 'h'
                axlims = [axlims(1)+panvect(1),...
                    axlims(2)+panvect(1),axlims(3)+panvect(2),...
                    axlims(4)+panvect(2)];
        end
        axis(axlims);
        panPoint1 = []; panPoint2 = [];
        set(haxes,'Units',origunits);
    end

end

function UpdateFigshift(in)

    set(hfig,'WindowButtonMotionFcn',@mouseMove1);%deactivate WBMF shift
%     if~exist('p','var')
        p=findobj(gca,'type','line');%get handles of all line in axis
%     end
    %for each line, update XY
    for k = 1:length(p)
        s=get(p(k),'userdata');
        s.k=k;
        s.x=get(p(k),'xdata');
        s.y=get(p(k),'ydata');
        s.xo=[];
        yp = get(p(k),'YData');
        xd = get(p(k),'XData');
        ocol = get(p(k),'Color');
        
        namepos = [(min(xd)-100), (max(yp))];
        if isfield(s,'hname')
            set(s.hname,'Position',namepos,...
                'String',s.name,'Color',ocol,'Visible','on');
        %       NOTE3 (see below)...
            if hidenames==1
                set(s.hname,'Visible','off');
            end
        end
        set(p(k),'UserData',s);
        set(p(k),'UserData',s,'ButtonDownFcn',{@clickFcn});
    end

end

% Called at scroll of mouse wheel:
function figScroll(source,event)
  zf = 1/8;     %increment of zoom per mouse scroll-wheel click
  axsize = [abs(axlims(2)-axlims(1)),abs(axlims(4)-axlims(3))];

  ptleft = 0; ptdown = 0;
  cthresh = 1/8;
  origunits = get(haxes,'Units');
  set(haxes,'Units','pixels');
  axlims = axis;

  zoomdir = 'C';
  % NOTE1 (see bottom)

  if event.VerticalScrollCount > 0           %Zoom out
      switch zoomdir
          case 'C'
              axlims = [axlims(1)-axsize(1)*zf/2,axlims(2)+axsize(1)*zf/2,...
                axlims(3)-axsize(2)*zf/2,axlims(4)+axsize(2)*zf/2];
          case 'DL'
              axlims = [axlims(1),axlims(2)+axsize(1)*zf,...
                  axlims(3),axlims(4)+axsize(2)*zf];
          case 'UL'
              axlims = [axlims(1),axlims(2)+axsize(1)*zf,...
                  axlims(3)-axsize(2)*zf,axlims(4)];
          case 'DR'
              axlims = [axlims(1)-axsize(1)*zf,axlims(2),...
                  axlims(3),axlims(4)+axsize(2)*zf];
          case 'UR'
              axlims = [axlims(1)-axsize(1)*zf,axlims(2),...
                  axlims(3)-axsize(2)*zf,axlims(4)];
      end
  end

  if event.VerticalScrollCount < 0           %Zoom in
      switch zoomdir
          case 'C'
              axlims = [axlims(1)+axsize(1)*zf/2,axlims(2)-axsize(1)*zf/2,...
                axlims(3)+axsize(2)*zf/2,axlims(4)-axsize(2)*zf/2];
          case 'DL'
              axlims = [axlims(1),axlims(2)-axsize(1)*zf,...
                  axlims(3),axlims(4)-axsize(2)*zf];
          case 'UL'
              axlims = [axlims(1),axlims(2)-axsize(1)*zf,...
                  axlims(3)+axsize(2)*zf,axlims(4)];
          case 'DR'
              axlims = [axlims(1)+axsize(1)*zf,axlims(2),...
                  axlims(3),axlims(4)-axsize(2)*zf];
          case 'UR'
              axlims = [axlims(1)+axsize(1)*zf,axlims(2),...
                  axlims(3)+axsize(2)*zf,axlims(4)];
      end
  end

  axis(axlims);
  set(haxes,'Units',origunits);

  % NOTE2 (set bottom)

end %figScroll

% Create a context menu:
function cmenu
    cmenu = uicontextmenu;
    % ch=findobj(gcf,'type','axes'); %for all axes
    set(ax, 'UIContextMenu', cmenu,'tag', 'context2');

    item1 = uimenu(cmenu, 'Label', [namecall,' Names'], ...
        'Callback',@hidenames_Callback);
    item2 = uimenu(cmenu, 'Label', 'Zoom Fit',...
        'Callback',@zoomAll_Callback);
    
end

% zoom to fit all plots
function zoomAll_Callback(source,event)
        
    for j = 1:length(ax)
        p=findobj(ax(j),'type','line');
        for k = 1:length(p)
            xdat=get(p(k),'Xdata');
            ydat=get(p(k),'Ydata');
            if k == 1
                xextent = [min(xdat),max(xdat)];
                yextent = [min(ydat),max(ydat)];
            else
                xextent = [min(xextent(1),min(xdat)),max(xextent(2),max(xdat))];
                yextent = [min(yextent(1),min(ydat)),max(yextent(2),max(ydat))];
            end
        end
        axis([xextent,yextent]);
    end
end

% hide plot names
function hidenames_Callback(source,event)
    hidenames = ~hidenames;
    UpdateFigshift
    if hidenames
        namecall = 'Show';
        cmenu;
    else set(s.hname,'Visible','on');
        namecall = 'Hide';
        cmenu;
    end
end

% new plot is selected
function groupclear
    UpdateFigshift();
    if exist('group','var')
        if ~isempty(group)
            for g = 1:length(group)
                s = get(group(g),'UserData');
                s.grp=0;
                set(group(g),'UserData',s,'LineWidth',1.5,'LineStyle','-');
            end
%             curr_s.grp = 0;
            clear group
            groupind = 0;
        end
    end
end

% updates selected 'group'
function groupupdate     
    groupind = length(group);
    for g = 1:groupind
        s = get(group(groupind),'UserData');
        s.grp=1;
%         s.xo=ptrval;   %reference values XY
        set(group(g),'UserData',s); %,'LineWidth',5);
    end
end

% @NOTE: for clearing selected group (next update...)
function clear_Callback(source,event)
    groupclear;
end

% For really big plots, resamples data when necessary... (next update...)
function[figout]= cropSheet()

     

end

end % figshift3

        

% NOTE1
% COMPLEX (NOT necessarily better) VERSION:  ----------------------
%      if ptrloc(1,1) < axlims(2)-axsize(1)/2, ptleft = 1; end
%      if ptrloc(1,2) < axlims(4)-axsize(2)/2, ptdown = 1; end
%       if ptrloc(1,1) < axlims(2)-axsize(1)/2+axsize(1)*cthresh...
%               && ptrloc(1,1)>axlims(2)-axsize(1)/2-axsize(1)*cthresh...
%               && ptrloc(1,2)<axlims(4)-axsize(2)/2+axsize(2)*cthresh...
%               && ptrloc(1,2)>axlims(4)-axsize(2)/2-axsize(2)*cthresh,
%           zoomdir = 'C';                          %zoom center
%       elseif ptleft&&ptdown, zoomdir = 'DL';      %zoom lower-left
%       elseif ptleft&&~ptdown, zoomdir = 'UL';     %zoom upper-left
%       elseif ~ptleft&&ptdown, zoomdir = 'DR';     %zoom lower-right
%       elseif ~ptleft&&~ptdown, zoomdir = 'UR';    %zoom upper-right
%       end

% NOTE2
% Attempt at zooming based on exact pointer location:
%   if evnt.VerticalScrollCount > 0           %Zoom out
%       if ~isempty(ptrloc)
%           axlims = [ptrloc(1,1)-(axsize(1)*(1+zf)/2),...    %xmin
%               ptrloc(1,1)+(axsize(1)*(1+zf)/2),...
%               ptrloc(1,2)-(axsize(2)*(1+zf)/2),...
%               ptrloc(1,2)+(axsize(2)*(1+zf)/2)];
%       else axlims = [axlims(1)-axsize(1)*zf,axlims(2)+axsize(1)*zf,...
%            axlims(3)-axsize(2)*zf,axlims(4)+axsize(2)*zf];
%       end
% 
%   elseif evnt.VerticalScrollCount < 0       %Zoom in
%       if ~isempty(ptrloc)
%           axlims = [ptrloc(1,1)-(axsize(1)*(1-zf)/2),...    %xmin
%               ptrloc(1,1)+(axsize(1)*(1-zf)/2),...
%               ptrloc(1,2)-(axsize(2)*(1-zf)/2),...
%               ptrloc(1,2)+(axsize(2)*(1-zf)/2)];
%       else axlims = [axlims(1)+axsize(1)*zf,axlims(2)-axsize(1)*zf,...
%           axlims(3)+axsize(2)*zf,axlims(4)-axsize(2)*zf];
%       end
%   end

% NOTE3: hide name if not in axis (axes val not pix pos)...
%         inAxes=(namepos(1)>=axpos(1)) && ...
%             (namepos(1)<axpos(1)+axpos(3)-100) && ...
%             (namepos(2)>axpos(2)) && ...
%             (namepos(2)<axpos(2)+axpos(4)-10);
%         if ~inAxes
%             set(s.hname,'Visible','off');
%         end

% NOTE4
%     %CONTROL-CLICK ============================================
%     case 'alt'          %select objects with click or rectangle
% 
%         if ~isempty(curr_s)     %Clicked on an object:
%             for i = 1:length(group)
%                 if group(i)==curr_obj
%                     dont=1;
%                 end
%             end
%             %crappy go-around to not duplicate in group (called from both
%             %windowbuttondownfcn and buttondownfcn):
%             if dont~=1
%                 groupind = length(group)+1;   %Adding to group
%                 group(groupind) = curr_obj;
%                 groupupdate;
%             end
%             dont=0;
%         else                    %Rectangle-drag to select:
%             selPoint1 = ptrval;
%             zr = rbbox([ptrloc,0,0]);
%             selPoint2 = ptrval;
%         end

