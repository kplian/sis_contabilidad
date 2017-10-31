<?php
// Extend the TCPDF class to create custom MultiRow
class RComprobanteDiario extends ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $s2;
	var $s3;
	var $s4;
	var $s5;
	var $s6;
	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $cant;
	var $valor;
	
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		//$this->datos_tpoestado = $tpoestado;
		//$this->datos_auxiliar = $auxiliar;
		$this->subtotal = 0;
		$this->SetMargins(20, 15, 5,10);
	}
	
	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,40,15,30,15,7,7,7,7,7,7,7,7,7);
		$conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C','C');
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$conf_tableborders=array();
		$conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;

		$RowArray = array
		(
			's0' => 'Nº',				
			's1' => 'Nro DE COMPROBANTE',
			's2' => 'FECHA',
			's3' => 'TIPO DE COMPROBANTE',
			's4' => 'COMPROMETIDO',
			's5' => 'EJECUTADO',
			's6' => 'PAGADO',
			's7' => 'MONEDA',
			's8' => 'CAMBIO',
			's9' => 'TC',
			's10' => 'TC',
			's11' => 'TC',
			's12' => 'TRAMITE',
			's13' => 'BENEFICIARIO'				
		);
		$this->MultiRow($RowArray, false, 1);
	}
	//
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$sw = false;
		$concepto = '';		
		$this->generarCuerpo($this->datos_detalle);
		if($this->s1 != 0){
			$this->SetFont('','B',6);
			$this->cerrarCuadro();	
			$this->cerrarCuadroTotal();
		}
	}
	//		
	function generarCuerpo($detalle){		
		//function
		$this->cab();
		//
		$count = 1;
		$sw = 0;
		$ult_region = '';
		$fill = 0;
		$this->total = count($detalle);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->s5 = 0;
		foreach ($detalle as $val) {			
			$this->imprimirLinea($val,$count,$fill);
			$fill = !$fill;
			$count = $count + 1;
			$this->total = $this->total -1;
			$this->revisarfinPagina();
		}
	}
	//desde 
	function imprimirLinea($val,$count,$fill){
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',6);

		$conf_par_tablewidths=array(7,50,80,20,20);
		$conf_par_tablealigns=array('C','L','L','R','R');		
		$conf_par_tablenumbers=array(0,0,0,2,2);
		$conf_tableborders=array('LR','LR','LR','LR','LR');		
		/*
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				$debe=$val['importe_debe_ma'];
				$haber=$val['importe_haber_ma'];		
				break;
			case 'MT':			
				$debe=$val['importe_debe_mt'];
				$haber=$val['importe_haber_mt'];
				break;
			case 'MB':
				$debe=$val['importe_debe_mb'];
				$haber=$val['importe_haber_mb'];			
				break;		
			default:			
				break;
		}
				
		$cc= (int)($this->objParam->getParametro('cc') === 'true');		
		$partida = (int)($this->objParam->getParametro('partida')=== 'true');
		$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
		$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
		$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
		$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
		$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
		$fec = (int)($this->objParam->getParametro('fec')=== 'true');	
		
		$aux='';		
		if($cc == 1){
			$aux=$aux.'CC:'.trim($val['desc_centro_costo'])."\r\n";			
		}else{			
			$aux=$aux.'';
		}
		if($partida == 1){
			$aux=$aux.'Ptda:'.trim($val['desc_partida'])."\r\n";
		}else{
			$aux=$aux.'';
		}
		if($auxiliar == 1){
			$aux=$aux.'Aux:'.trim($val['desc_auxiliar'])."\r\n";
		}else{
			$aux=$aux.'';
		}
		if($ordenes == 1){
			$aux=$aux.'Ptda:'.trim($val['desc_partida'])."\r\n";
		}else{
			$aux=$aux.'';
		}
		if($tramite == 1){
			$aux=$aux.'Tramite:'.strval($val['nro_tramite'])."\r\n";
		}else{
			$aux=$aux.'';
		}
		if($crel == 1 ){
			$aux=$aux.'Cbte Relacional:'.$val['cbte_relacional']."\r\n";
		}else{
			$aux=$aux.'';
		}		
		if($nro_comprobante == 1){
			$aux=$aux.'Nro Cbte.:'.trim($val['nro_cbte'])."\r\n";
		}else{
			$aux=$aux.'';
		}	
		if($fec == 1){
			$arr = explode('-', $val['fecha']);
			$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
			$aux=$aux.'Fecha:'.$newDate."\r\n";
		}else{
			$aux=$aux.'';
		}	*/		
		//			
		/*
		$RowArray = array(  's0' => $count,
							's1' => $val['nro_cbte']
						);
		*/									
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		//$this->calcularMontos($val);		
		$this-> MultiRow($RowArray,$fill,0);
	} 
	//desde generarcuerpo
	function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$x=0;
		$this->getNumLines($row['cell1data'], 90);

		if ($startY > 230) {
			//$this->cerrarCuadro();
			//$this->cerrarCuadroTotal();
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}
			
		}
	}
	//
	function Footer() {		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
	}
	//
	//imprimirLinea suma filas
	function calcularMontos($val){
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				$this->s1 = $this->s1 + $val['importe_debe_ma'];
				$this->s2 = $this->s2 + $val['importe_haber_ma'];		
				break;
			case 'MT':			
				$this->s1 = $this->s1 + $val['importe_debe_mt'];
				$this->s2 = $this->s2 + $val['importe_haber_mt'];
				break;
			case 'MB':
				$this->s1 = $this->s1 + $val['importe_debe_mb'];
				$this->s2 = $this->s2 + $val['importe_haber_mb'];			
				break;		
			default:			
				break;
		}
		
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				$this->t1 = $this->t1 + $val['importe_debe_ma'];
				$this->t2 = $this->t2 + $val['importe_haber_ma'];		
				break;
			case 'MT':			
				$this->t1 = $this->t1 + $val['importe_debe_mt'];
				$this->t2 = $this->t2 + $val['importe_haber_mt'];
				break;
			case 'MB':
				$this->t1 = $this->t1 + $val['importe_debe_mb'];
				$this->t2 = $this->t2 + $val['importe_haber_mb'];			
				break;		
			default:			
				break;
		}			
	}	
	//revisarfinPagina pie
	function cerrarCuadro(){
		//si noes inicio termina el cuardro anterior
		$conf_par_tablewidths=array(7,80,15,15,15);				
		$this->tablealigns=array('R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,2,2);
		$this->tableborders=array('T','T','T','LRTB','LRTB');						
		$RowArray = array(  's1' => '',
							's2' => '', 
							'espacio' => 'Subtotal',
							's3' => $this->s1,
							's4' => $this->s2
						);		
		$this-> MultiRow($RowArray,false,1);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
	}
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(7,80,15,15,15);				
		$this->tablealigns=array('R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,2,2);
		$this->tableborders=array('','','','LRTB','LRTB');		
							
		$RowArray = array( 
					't1' => '',
					't2' => '',
					'espacio' => 'TOTAL: ',
					't3' => $this->t1,
					't4' => $this->t2
				);
		$this-> MultiRow($RowArray,false,1);
	}
	
	function cab() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"LIBRO DIARIO",0,1,'C');					
		$this->Ln(3);
		
		$height = 5;
		$width1 = 5;
		$esp_width = 10;
		$width_c1= 30;
		$width_c2= 50;			
		/*
		if($this->objParam->getParametro('desde')!=null){
			$desde = $this->objParam->getParametro('desde');
			$cant++;	
		}
		if($this->objParam->getParametro('hasta')!=null){
			$hasta = $this->objParam->getParametro('hasta');
			$cant++;	
		}
		if($this->objParam->getParametro('aux')!=null){
			$aux = $this->objParam->getParametro('aux');
			$cant++;	
		}
		if($this->objParam->getParametro('gest')!=null){
			$gest = $this->objParam->getParametro('gest');
			$cant++;	
		}
		if($this->objParam->getParametro('depto')!=null){
			$depto = $this->objParam->getParametro('depto');
			$cant++;	
		}						
		if($this->objParam->getParametro('config_tipo_cuenta')!=null){
			$config_tipo_cuenta = $this->objParam->getParametro('config_tipo_cuenta');
			$cant++;	
		}			
		if($this->objParam->getParametro('config_subtipo_cuenta')!=null){
			$config_subtipo_cuenta = $this->objParam->getParametro('config_subtipo_cuenta');
			$cant++;	
		}				
		if($this->objParam->getParametro('cuenta')!=null){
			$cuenta = $this->objParam->getParametro('cuenta');
			$cant++;	
		}
		if($this->objParam->getParametro('partidas')!=null){
			$partidas = $this->objParam->getParametro('partidas');
			$cant++;	
		}
		if($this->objParam->getParametro('tipo_cc')!=null){
			$tipo_cc = $this->objParam->getParametro('tipo_cc');
			$cant++;	
		}			
		if($this->objParam->getParametro('centro_costo')!=null){
			$centro_costo = $this->objParam->getParametro('centro_costo');
			$cant++;	
		}		
		if($this->objParam->getParametro('orden_trabajo')!=null){
			$orden_trabajo = $this->objParam->getParametro('orden_trabajo');
			$cant++;	
		}
		if($this->objParam->getParametro('suborden')!=null){
			$suborden = $this->objParam->getParametro('suborden');
			$cant++;	
		}
		if($this->objParam->getParametro('nro_tram')!=null){
			$nro_tram = $this->objParam->getParametro('nro_tram');
			$cant++;	
		}
		//
		$valor =$cant;	
		if($this->objParam->getParametro('gest')!=null){			
			$gest=$this->objParam->getParametro('gest');
			$this->SetFont('', 'B',6);
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->Cell($width_c1, $height, 'Gestion:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $gest, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
								
		if($this->objParam->getParametro('desde')!=null){			
			$fecha_ini =$this->objParam->getParametro('desde');
			$this->SetFont('', 'B',6);
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height, 'Del:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $fecha_ini, 0, 1, 'L', true, '', 0, false, 'T', 'C');	
			$this->Ln();		
		}
		if($this->objParam->getParametro('hasta')!=null){		
			$fecha_fin = $this->objParam->getParametro('hasta');
			$this->SetFont('', 'B',6);		
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Hasta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $fecha_fin, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();			
		}
				
		if($this->objParam->getParametro('aux')!=null){		
			$aux = $this->objParam->getParametro('aux');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Auxiliar:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $aux, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('depto')!=null){		
			$depto= $this->objParam->getParametro('depto');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Departamento:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $depto, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('config_tipo_cuenta')!=null){		
			$config_tipo_cuenta= $this->objParam->getParametro('config_tipo_cuenta');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Tipo de Cuenta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $config_tipo_cuenta, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('config_subtipo_cuenta')!=null){
			$this->SetFont('', 'B',6);		
			$config_subtipo_cuenta= $this->objParam->getParametro('config_subtipo_cuenta');					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Sub Tipo de Cuenta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $config_subtipo_cuenta, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('config_subtipo_cuenta')!=null){
			$this->SetFont('', 'B',6);		
			$config_subtipo_cuenta= $this->objParam->getParametro('config_subtipo_cuenta');					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Sub Tipo de Cuenta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $config_subtipo_cuenta, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('cuenta')!=null){
			$this->SetFont('', 'B',6);		
			$cuenta= $this->objParam->getParametro('cuenta');					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Cuenta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $cuenta, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}

		if($this->objParam->getParametro('partidas')!=null){		
			$partidas= $this->objParam->getParametro('partidas');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Partida:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $partidas, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
		
		if($this->objParam->getParametro('tipo_cc')!=null){		
			$tipo_cc = $this->objParam->getParametro('tipo_cc');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Tipo de Centro de Costo :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $tipo_cc, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}
						
		if($this->objParam->getParametro('centro_costo')!=null){		
			$centro_costo= $this->objParam->getParametro('centro_costo');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Centro de Costo:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $centro_costo, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}	
		
		if($this->objParam->getParametro('orden_trabajo')!=null){		
			$orden_trabajo= $this->objParam->getParametro('orden_trabajo');	
			$this->SetFont('', 'B',6);				
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Orden de Trabajo:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $orden_trabajo, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}				
		
		if($this->objParam->getParametro('suborden')!=null){		
			$suborden= $this->objParam->getParametro('suborden');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Sub Orden:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $suborden, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}	
		
		if($this->objParam->getParametro('nro_tram')!=null){		
			$nro_tram= $this->objParam->getParametro('v');
			$this->SetFont('', 'B',6);					
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height,'Nro de Tramite:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $nro_tram, 0, 1, 'L', true, '', 0, false, 'T', 'C');
			$this->Ln();		
		}*/
		
		$this->Ln(4);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}	
}
?>