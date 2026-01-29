function [optimo, costo_minimo] = PSO_r(problema, nvar, busqueda, param, ros)
    %Implementación de PSO, recibe la función, la dimensión,  una
    %matriz con el espacio de búsqueda, un vector de parámetros.
    %la entrada opt son parámetros de la función de Rosenbrock
    
    %Inicialización de parámetros
    a = ros.a; b = ros.b;
    func = problema;
    varsize = [1 nvar]; 
    itermax = param.itermax;
    npop = param.npop;
    w = param.w;
    wdamp = param.wdamp;
    c1 = param.c1;
    c2 = param.c2;
    
    %Espacio de búsqueda
    xmin = busqueda.xmin;
    xmax = busqueda.xmax;
    vmin = busqueda.vmin;
    vmax = busqueda.vmax;
    globest.cost = inf;
    
    %Condiciones iniciales
    init.loc = [];
    init.vel = [];
    init.cost = [];
    init.best.loc = [];
    init.best.cost = [];
    enjambre = repmat(init, npop, 1);  %Se inicializan las partículas
 %Se guarda la memoria de la iteración 0
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
   tic 
    %Se actualizan segun las reglas de PSO
    for iter = 1:itermax
        [X,Y] = meshgrid(xmin:0.1:xmax, xmin:0.1:xmax);
        contour(X,Y,(a-X).^2 + b*(Y-X.^2).^2, 100); hold on;
        scatter(a,a.^2,35,'ok','filled');
        title(['Función de Rosenbrock, a=  ' num2str(a) ', b = ' num2str(b)]);
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
%Se grafica el moviemiento en las partículas
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
        
%El siguiente código genera la animación.
        frame(iter) = getframe(gcf); pause(0.0001);
        hold off;
        
        bestcost(iter) = globest.cost;
        disp(['Iteration ' num2str(iter) ' | Minimum cost = ' num2str(bestcost(iter))] );
        w = w*wdamp;
    end
    name = ['Rosenbrock a=' num2str(a) ' b=' num2str(b) ' pop=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,frame);
    close(video)
    
    clf
    for iter = 1:itermax
        semilogy(1:iter,bestcost(1:iter));
        axis([1 itermax 1e-15 1 ]);
        title(['Valor mínimo vs. Población = ' num2str(npop) ' | Mínimo global = ' num2str(bestcost(iter))] );
        frame(iter) = getframe(gcf); pause(0.0001);        
    end
    
    name = ['Convergencia a=' num2str(a) ' b=' num2str(b) ' pop=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,frame);
    close(video)
    
    optimo = globest;
    costo_minimo = bestcost;
end