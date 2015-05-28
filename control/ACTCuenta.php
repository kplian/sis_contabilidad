<?php
/**
*@package pXP
*@file ACTCuenta.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RPlanCuentas.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
class ACTCuenta extends ACTbase{    
			
	function listarCuenta(){
		$this->objParam->defecto('ordenacion','id_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("cta.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
		
		if($this->objParam->getParametro('id_partida')!=''){
            $this->objParam->addFiltro("cta.id_cuenta IN (select id_cuenta 
            							from conta.tcuenta_partida where id_partida = ".$this->objParam->getParametro('id_partida') . ") ");    
        }
        
        
        if($this->objParam->getParametro('sw_transaccional')!=''){
            $this->objParam->addFiltro("cta.sw_transaccional = ''".$this->objParam->getParametro('sw_transaccional')."''"); 
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuenta','listarCuenta');
		} else{
			$this->objFunc=$this->create('MODCuenta');
			
			$this->res=$this->objFunc->listarCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCuentaArb(){
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_cuenta');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_cuenta);
        }
        
								$this->objFunc=$this->create('MODCuenta');
        $this->res=$this->objFunc->listarCuentaArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_cuenta'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_cuenta_padre'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #nro_cuenta# - #nombre_cuenta#</b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'nombre_cuenta'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #nro_cuenta#</b><br/><b> #nombre_cuenta#</b><br> #desc_cuenta#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
														
		
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

 }
				
	function insertarCuenta(){
		$this->objFunc=$this->create('MODCuenta');	
		if($this->objParam->insertar('id_cuenta')){
			$this->res=$this->objFunc->insertarCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuenta(){
			$this->objFunc=$this->create('MODCuenta');	
		$this->res=$this->objFunc->eliminarCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function recuperarDatosPlanCuentas(){
    	
		$this->objFunc = $this->create('MODCuenta');
		$cbteHeader = $this->objFunc->listarPlanCuentas($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
				
			return $cbteHeader->getDatos();
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function reportePlanCuentas(){
			
		$nombreArchivo = uniqid(md5(session_id()).'PlanCuentas') . '.pdf'; 
		$dataSource = $this->recuperarDatosPlanCuentas();	
		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'P';
		$titulo = 'Plan de Cuentas Gestón XXXX';
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);	
        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		
		$reporte = new RPlanCuentas($this->objParam);
		$reporte->datosHeader($dataSource);
		//$this->objReporteFormato->renderDatos($this->res2->datos);
		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

    function reportePlanCuentas_bk(){
   	    	
   	   
		$dataSource = new DataSource();	
		$dataSource->putParameter('cabecera',$this->recuperarDatosPlanCuentas());
   	   	 /*
   	   	 $cabecera = $dataSource->getParameter('cabecera');
   	   	 foreach($cabecera as $key=>$val){
		 	echo $val['nro_cuenta'].'<br>';
		 }
   	    //var_dump($dataSource->getParameter('cabecera'));
		exit;*/
	    try
	    {// get the HTML
		    ob_start();
		    include(dirname(__FILE__).'/../reportes/tpl/planCuentas.php');
	        $content = ob_get_clean();
	    	
			//$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
			$pdf = new TCPDF();
			$pdf->SetDisplayMode('fullpage');
			// set document information
            $pdf->SetCreator(PDF_CREATOR);
			// set default header data
			// set default monospaced font
			$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
			
			// set margins
			$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
			$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
			$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
			
			// set auto page breaks
			$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
			
			// set font
			$pdf->SetFont('helvetica', '', 10);
			// add a page
            $pdf->AddPage();
			$pdf->writeHTML($content, true, false, true, false, '');
			$nombreArchivo = 'PlanCuentas.pdf';
			$pdf->Output(dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo, 'F');
			
			$mensajeExito = new Mensaje();
            $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->res = $mensajeExito;
            $this->res->imprimirRespuesta($this->res->generarJson());
			
		}
	    catch(exception $e) {
	        echo $e;
	        exit;
	    }
    }
			
}

?>