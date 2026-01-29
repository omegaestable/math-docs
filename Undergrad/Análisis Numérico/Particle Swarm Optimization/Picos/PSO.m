function [enjambre, costo_minimo] = PSO(problema, nvar, bound, param)
    
 %Implementaci�n de PSO, recibe la funci�n, la dimensi�n,  una
    %matriz con el espacio de b�squeda, un vector de par�metros.
    
    %Inicializaci�n de par�metros.
    func = problema;
    varsize = [1 nvar]; 
    itermax = param.itermax;
    npop = param.npop;  %Poblaci�n del enjambre
    w = param.w;     %omega
    wdamp = param.wdamp;
    c1 = param.c1;
    c2 = param.c2;
    xmin = bound.xmin;
    xmax = bound.xmax;
    vmin = bound.vmin;
    vmax = bound.vmax;
    
    globest.cost = inf;
    
    init.loc = [];
    init.vel = [];
    init.cost = [];
    init.best.loc = [];
    init.best.cost = [];

    enjambre = repmat(init, npop, 1);
%Se inicializan todas las particulas y se inicializan sus memorias
    for i = 1:npop
        enjambre(i).loc = unifrnd(xmin, xmax, varsize);
        enjambre(i).vel = zeros(varsize);
        enjambre(i).cost = func(enjambre(i).loc);
        enjambre(i).best.loc = enjambre(i).loc;
        enjambre(i).best.cost = enjambre(i).cost;   

        if enjambre(i).best.cost < globest.cost
            globest = enjambre(i).best;
        end
    end

    bestcost = zeros(itermax,1);
    tempX = zeros(itermax,npop);
    tempY = zeros(itermax,npop);
     %Se actualiza en cada iteracion
     tic
    for iter = 1:itermax
        [X,Y] = meshgrid(xmin:0.1:xmax, xmin:0.1:xmax);
        contour(X,Y,3*(1-X).^2.*exp(-(X.^2) - (Y+1).^2) - 10*(X/5 - X.^3 - Y.^5).*exp(-X.^2-Y.^2) ... 
                - 1/3*exp(-(X+1).^2 - Y.^2), 25); hold on;
        scatter(0.2283,-1.6255,35,'ok','filled');
        title('Funci�n picos de MATLAB');
        for i = 1:npop
            enjambre(i).vel =  min(max(w*enjambre(i).vel + c1*rand(varsize).*(enjambre(i).best.loc ...
                            - enjambre(i).loc) + c2*rand(varsize).*(globest.loc - enjambre(i).loc),vmax),vmin);
            enjambre(i).loc = min(max(enjambre(i).loc + enjambre(i).vel, xmin),xmax);
            enjambre(i).cost = func(enjambre(i).loc);
            
            if enjambre(i).cost < enjambre(i).best.cost
                enjambre(i).best.loc = enjambre(i).loc;
                enjambre(i).best.cost = enjambre(i).cost;

                if enjambre(i).best.cost < globest.cost
                    globest = enjambre(i).best;
                end
            end
            tempX(iter,i) = enjambre(i).loc(1);
            tempY(iter,i) = enjambre(i).loc(2);
        end
        toc
%Se grafican los movimientos
        scatter(tempX(iter,:),tempY(iter,:),'xb');
        if(iter <=5)
            for i = 1:npop
                line(tempX(1:iter,i),tempY(1:iter,i));
            end            
        else
            for i = 1:npop
                line(tempX(iter-5:iter,i),tempY(iter-5:iter,i));
            end
        end
%Se anima
        frame(iter) = getframe(gcf); pause(0.0001);
        hold off;
        
        bestcost(iter) = globest.cost;
        disp(['Iteraci�n ' num2str(iter) ' Valor m�nimo = ' num2str(bestcost(iter))] );
        w = w*wdamp;
    end
    name = ['Poblaci�n en los picos=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,frame);
    close(video)
    
    clf
    for iter = 1:itermax
        plot(1:iter,bestcost(1:iter));
        axis([1 itermax -7 0 ]);
        title(['Valor m�nimo versus poblaci�n ' num2str(npop) ' Valor m�nimo = ' num2str(bestcost(iter))] );
        frame(iter) = getframe(gcf); pause(0.0001);        
    end
    
    name = ['Convergencia pop=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,frame);
    close(video)
    
    enjambre = globest;
    costo_minimo = bestcost;
end