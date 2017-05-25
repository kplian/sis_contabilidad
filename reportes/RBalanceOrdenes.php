<?php

// Extend the TCPDF class to create custom MultiRow
class RBalanceOrdenes extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $desde;
	var $hasta;
	var $nivel;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $codigos;
	var $total_activo;
	var $total_pasigo;
	var $total_patrimonio;
	var $total_ingreso;
	var $total_egreso;
	var $tipo_balance;
	var $incluir_cierre;
	
	function datosHeader ( $detalle, $nivel, $desde, $hasta, $codigos, $tipo_balance, $incluir_cierre) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->nivel = $nivel;
		$this->desde = $desde;
		$this->hasta = $hasta;
		$this->codigos = $codigos;
		$this->incluir_cierre = $incluir_cierre;
		$this->tipo_balance = $tipo_balance;
		//$this->SetMargins(5, 22.5, 5);
		$this->SetMargins(5,40);
	}
	
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->ln(5);
		$this->SetFont('','BU',12);
		if($this->tipo_balance == 'resultado'){
			$this->Cell(0,5,'ESTADO DE RESULTADOS (BS)',0,1,'C');
		}
		else{
			$this->Cell(0,5,'ÁRBOL DE ORDENES DE COSTOS (BS)',0,1,'C');
		}
		
		$this->SetFont('','BU',11);
		$this->Cell(0,5,'Depto: ('.$this->codigos.')',0,1,'C');
		$this->SetFont('','BU',10);		
		$this->Cell(0,5,'Del '.$this->desde.' al '.$this->hasta,0,1,'C');
		$this->SetFont('','BU',8);		
		$this->Cell(0,5,'Incluye Cierres: '.$this->incluir_cierre,0,1,'C');
		
		
		$this->Ln(3);
		$this->SetFont('','B',10);
		
		//REporte de unasola columna de monto
		if($this->nivel == 1 || $this->nivel > 3 ){
			//Titulos de columnas superiores
			$this->Cell(160,3.5,'Ordenes','',0,'C');
			$this->Cell(40,3.5,'Montos (Bs)','',0,'C');
			$this->ln();	
		}
		//reporte de dos columnas de montos
		if($this->nivel == 2 ){
			//Titulos de columnas superiores
			$this->Cell(154,3.5,'Ordenes','',0,'C');
			$this->Cell(23,3.5,'Mon','',0,'R');
			$this->Cell(23,3.5,'tos (Bs)','',0,'L');
			$this->ln();	
			
		}
		
		if($this->nivel == 3 ){
			//Titulos de columnas superiores
			$this->Cell(131,3.5,'Ordenes','',0,'C');
			$this->Cell(23,3.5,'','',0,'R');
			$this->Cell(23,3.5,'Montos (Bs)','',0,'C');
			$this->Cell(23,3.5,'','',0,'L');
			$this->ln();
			
		}
		
   }
	
	function generarReporte() {
		
		$this->total_activo = 0;
	    $this->total_pasigo = 0;
	    $this->total_patrimonio = 0;
		$this->total_ingreso = 0;
		$this->total_egreso = 0;		
		//Reporte de unasola columna de monto
		if($this->nivel == 1 || $this->nivel > 3 ){
		    $this->generarReporte1C();
		}
		//reporte de dos columnas de montos
		if($this->nivel == 2 ){
		     $this->generarReporte2C();
		}
		//reporte de tres columnas de montos
		if($this->nivel == 3 ){
		     $this->generarReporte3C();
		}
		
		//escribe formula contabla
		$this->SetFont('times', 'BI', 17);
		$tactivo = number_format( $this->total_activo , 2 , '.' , ',' );
		$tpasivo = number_format( $this->total_pasivo , 2 , '.' , ',' );
		$tpatrimonio = number_format( $this->total_patrimonio , 2 , '.' , ',' );
		$tingreso = number_format( $this->total_ingreso , 2 , '.' , ',' );
		$tegreso = number_format( $this->total_egreso , 2 , '.' , ',' );
		$resultado = $this->total_ingreso - $this->total_egreso;
		$resultado = number_format( $resultado , 2 , '.' , ',' );
		 $sw_dif = 0;
		if($this->tipo_balance == 'general'){
			$formula = "ACTIVO =  PASIVO + PATRIMONIO";
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
			$formula = "$tactivo =  $tpasivo + $tpatrimonio";
			if(($this->total_activo +  $this->total_egreso) !=($this->total_pasivo + $this->total_patrimonio + $this->total_ingreso)){
				$this->SetTextColor(0,100,100,0,false,'');
			    $sw_dif = 1;
			}
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);	
		}
		elseif($this->tipo_balance == 'resultado'){
			$formula = "RESULTADO =  INGRESOS - EGRESOS";
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
			
			$formula = "$resultado =  $tingreso - $tegreso";
			
			if(($this->total_ingreso - $this->total_egreso) < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			  
			}
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);	
		}
		else{
			
			
			$formula = "ACTIVO + GASTOS =  PASIVO + PATRIMONIO + INGRESOS";
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
			$formula = "$tactivo  + $tegreso =  $tpasivo + $tpatrimonio + $tingreso";
			if(($this->total_activo +  $this->total_egreso) != ($this->total_pasivo + $this->total_patrimonio + $this->total_ingreso)){
				$this->SetTextColor(0,100,100,0,false,'');
				  $sw_dif = 1;
			}
			$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
		}
		if( $sw_dif == 1){
			$diferencia = ($this->total_activo +  $this->total_egreso) - ($this->total_pasivo + $this->total_patrimonio + $this->total_ingreso);
		    if($diferencia < 0){
		    	$diferencia = $diferencia * (-1);
		    }
			$formula = number_format( $diferencia , 2 , '.' , ',' );
			$this->Write(0, 'Diferencia de: '.$formula, '', 0, 'C', true, 0, false, false, 0);
		}
		
		
		
	}
	function definirTotales($val){
		if($val ["nivel"] ==1 && $val ["tipo_cuenta"] == 'activo'){
			$this->total_activo = $val['monto'];
		}
		if($val ["nivel"] == 1 && $val ["tipo_cuenta"] == 'pasivo'){
			$this->total_pasivo = $val['monto'];
		}
		if($val ["nivel"] ==1 && $val ["tipo_cuenta"] == 'patrimonio'){
			$this->total_patrimonio = $val['monto'];
		}
		
		//calculo total de egreso		
		if($val ["nivel"] == 1 && $val ["movimiento"] == 'egreso'){
			$this->total_egreso = $this->total_egreso + $val['monto'];
		}
		//calculo ingreso
		if($val ["nivel"] == 1 && $val ["movimiento"] == 'ingreso'){
			$this->total_ingreso = $this->total_ingreso + $val['monto'];
		}
		
		
	}
	
	function generarReporte1C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        foreach ($this->datos_detalle as $val) {
	       		
			$this->definirTotales($val);	
	       	$tabs = "";
		    for($i = 1; $i < $val ["nivel"]; $i++){
		    	$tabs = $tabs."\t\t\t\t";
		    } 
        	  
	      
			$this->Cell(160,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
           if($val['nivel'] == 1){
           	   $this->SetFont('','BU',11);
			   $this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->SetFont('','',9);
			  
			}
		   if($val['nivel'] == 2){
           	   $this->SetFont('','BU',10);
			   $this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->SetFont('','',9);
			  
			}
			else{
				$this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			}
			
			$this->ln();
			
			//colores por defecto
			$this->SetTextColor(0,-1,-1,-1,false,'');		
				
			
		}	//Titulos de columnas inferiores 
			$this->Cell(160,3.5,'','',0,'L');
			$this->Cell(40,3.5,'','',0,'R');			
			$this->ln();
	}
	
	function generarReporte2C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	$this->definirTotales($val);
			if($val['nivel'] == 2){
				$tabs = "\t\t\t\t";
			}
			else{
				$tabs = "";
			}
        	  
	       // $this->Cell(40,3.5,,'LTR',0,'L');
			$this->Cell(154,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 2){
			   $this->Cell(23,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			}
			else{
				$this->SetFont('','BU',10);
		        $this->Cell(23,3.5, "" ,'',0,'R');
				$this->Cell(23,3.5, number_format( $val['monto'], 2 , '.' , ',' ) ,'',0,'R');	
				$this->SetFont('','',9);
			}
			
			$this->ln();	
			$this->SetTextColor(0,-1,-1,-1,false,'');	
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(154,3.5,'','',0,'L');
			$this->Cell(23,3.5,'','',0,'R');	
			$this->Cell(23,3.5,'','',0,'R');					
			$this->ln();
	}

    function generarReporte3C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	$this->definirTotales($val);
			if($val['nivel'] == 3){
				$tabs = "\t\t\t\t\t\t\t\t";
			}
			elseif($val['nivel'] == 2){
				$tabs = "\t\t\t\t";
			}
			else{
				$tabs = "";
			}
			
        	  
	       // $this->Cell(40,3.5,,'LTR',0,'L');
			$this->Cell(131,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 3){
			   $this->Cell(23,3.5, number_format( $val['monto'] ,2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			}
			elseif($val['nivel'] == 2){
			   $this->SetFont('','B',10);
			   $this->Cell(25,3.5,"",'',0,'R');
			   $this->Cell(22,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(22,3.5,"",'',0,'R');
			   $this->SetFont('','',9);
			  
			}
			else{
				$this->SetFont('','BU',11);
		        $this->Cell(25,3.5, "" ,'',0,'R');
				$this->Cell(22,3.5,"",'',0,'R');
				$this->Cell(22,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');	
				
				$this->SetFont('','',9);
			}
			//Setea colo dfecto
			$this->SetTextColor(0,-1,-1,-1,false,'');
			
			$this->ln();	
				
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(131,3.5,'','',0,'L');
			$this->Cell(25,3.5,'','',0,'R');	
			$this->Cell(22,3.5,'','',0,'R');
			$this->Cell(22,3.5,'','',0,'R');						
			$this->ln();
	}  
}
?>

