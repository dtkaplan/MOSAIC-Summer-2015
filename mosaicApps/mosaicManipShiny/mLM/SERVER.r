library(mosaicData)

  shinyServer(
    
    function(input,output,session){
      
      # graphics function  function(xname,vec)
      ffun <- reactive({
        
        if(input$plot == 0){
          return (NULL)
        }
        
        xname <- isolate(input$var_choices)
        vec <<- c(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
        formula <- as.formula(isolate(input$expr))
        data <- datasets[[isolate(input$data)]]
        
        mod <- lm( formula, data=data)
        response.name <- deparse(mod$terms[[2L]])   #reponse.name <- formula[2]
        term.labels <- attr(mod$term, "term.labels")
        validate(need(xname %in% term.labels, "Please choose x variable properly")) #validation error
        
        col.to.term <- (mod$assign)
        if( attr(mod$term, "intercept") == 1 ){
          term.labels <- c("Intercept", term.labels)
          col.to.term <- col.to.term + 1
        }
        keep.vector <- (1:length(term.labels))
        mat <- model.matrix(mod)
        response <- fitted(mod) + resid(mod)
        if (length(term.labels) > 20)
          stop("Too many terms.  Ask DTK to fix this.")
        
        yscale <- range(response)
        yscale <- yscale - diff(yscale)*(c(-1,1)*.05)

        n <- length(term.labels)
        keep.columns <- col.to.term %in% keep.vector[ vec[1:n] ]
        if ( sum(keep.columns)==0  ) {
          yscale <- range(c(response,0)) #include 0 in the scale
          newvals <- 0*response
        }
        else {
          newmat <- mat[,keep.columns]
          if (!is.matrix(newmat) ) newmat <- cbind(newmat)
          # make sure it's a matrix.
          #eliminate redundant columns
          qq <- qr(newmat)
          keep <- 1e-6 < abs(diag(qr.R(qq)))
          newmat <- qr.Q(qq)%*%(qr.R(qq)[,keep])
          newvals <- newmat %*% qr.solve( newmat, response, tol=1e-15 )
        }
        xvar <- mod$model[[xname]]
        if( is.factor( xvar ) ){
          xxvar <- jitter(as.numeric(xvar) )
          # DO THE PLOT labeling the x-axis with the levels of the factor
          plot(xxvar, newvals,pch=20,
               ylab=response.name,xlab=xname, col="black",xaxt="n",ylim=yscale)
          axis(1, at= 1:length(levels(xvar)), labels=levels(xvar) )
        }
        else {
          xxvar <- xvar # just for symmetry with the is.factor case above.
          plot( xxvar, newvals,pch=20,
                ylab=response.name,xlab=xname, col="black",ylim=yscale)
        }
        
        points(xxvar, response, pch=20, col=rgb(0,0,1,.3) )
        foo <- par("usr")
        goo <- par("pin")
        text(foo[1],foo[4]+.05*(foo[4]-foo[3]),
             paste("R^2=",signif(var(newvals)/var(response),3)),pos=4,xpd=NA)
        
      })
      
      observeEvent(input$data,{
        updateSelectInput(session, inputId = "var_choices", choices = names(datasets[[input$data]]), selected = NULL)
      })
      
      
      output$graph <- renderPlot({
        p <- ffun()
        
        p
      })
      
      

      
      
    })
  
