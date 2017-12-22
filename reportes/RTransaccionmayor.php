<?php
// Extend the TCPDF class to create custom MultiRow
class RTransaccionmayor extends ReportePDF {
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
	var $signo="";
	var $a="";
	
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		$this->SetMargins(10, 15, 5,10);
	}
	//
	function getDataSource(){
		return  $this->datos_detalle;		
	}
	//
	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,15,50,60,20,20,20);
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0);
		$conf_par_tablealigns=array('C','C','C','C','C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$valor=$a;
		$var = $this->objParam->getParametro('tipo_moneda');//MT MA MB
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'FECHA',
							's2' => 'DESCRIPCION',
							's3' => 'GLOSA',
							's4' => 'DEBE'."\r\n".$var,
							's5' => 'HABER'."\r\n".$var,
							's6' => 'SALDO'
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);
	}
	//		
	function generarCuerpo($detalle){		
		//function
		$this->cab();
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
		$this->imprimirLinea($val,$count,$fill);
	}
	//desde 
	function imprimirLinea($val,$count,$fill){
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',6);
		$acreedor=0;
		foreach ($this->getDataSource() as $datarow) {
			
			switch ($this->objParam->getParametro('tipo_moneda')) {
				case 'MA':
					$debe=$datarow['importe_debe_ma'];
					$haber=$datarow['importe_haber_ma'];		
					break;
				case 'MT':			
					$debe=$datarow['importe_debe_mt'];
					$haber=$datarow['importe_haber_mt'];
					break;
				case 'MB':
					$debe=$datarow['importe_debe_mb'];
					$haber=$datarow['importe_haber_mb'];			
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
			$cuenta_t = (int)($this->objParam->getParametro('cuenta_t')=== 'true');	
			
			$aux='';	
			
			if($nro_comprobante == 1){
				$aux=$aux.'Nro Cbte.:'.trim($datarow['nro_cbte'])."\r\n";
			}else{
				$aux=$aux.'';
			}	
			if($tramite == 1){
				$aux=$aux.'Tramite:'.strval($datarow['nro_tramite'])."\r\n";
			}else{
				$aux=$aux.'';
			}
			if($cuenta_t == 1){
				$aux=$aux.'Cta. Contable:'.trim($datarow['desc_cuenta'])."\r\n";
			}else{
				$aux=$aux.'';
			}	
			if($partida == 1){
				$aux=$aux.'Ptda:'.trim($datarow['desc_partida'])."\r\n";
			}else{
				$aux=$aux.'';
			}
			if($cc == 1){
				$aux=$aux.'CC:'.trim($datarow['desc_centro_costo'])."\r\n";			
			}else{			
				$aux=$aux.'';
			}
			if($ordenes == 1){ 
				$aux=$aux.'Ptda:'.trim($datarow['desc_partida'])."\r\n";
			}else{
				$aux=$aux.'';
			}	
			if($auxiliar == 1){
				$aux=$aux.'Aux:'.trim($datarow['desc_auxiliar'])."\r\n";
			}else{
				$aux=$aux.'';
			}					
			if($crel == 1 ){
				$aux=$aux.'Cbte Relacional:'.$datarow['cbte_relacional']."\r\n";
			}else{
				$aux=$aux.'';
			}									
			
			/*if($fec == 1){
				$arr = explode('-', $datarow['fecha']);
				$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
				$aux=$aux.'Fecha:'.$newDate."\r\n";
			}else{
				$aux=$aux.'';
			}	*/
			
			$arr = explode('-', $datarow['fecha']);
			$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
			
			$acreedor = ($debe-$haber) + $acreedor;								
			if($acreedor<0){
				$this->tablenumbers=array(0,0,0,0,2,2,0);
				$acreedor=$acreedor*-1;
				$acreedor= '('.(string)(number_format($acreedor, 2, '.', ',')).')';
			}else{
				$this->tablenumbers=array(0,0,0,0,2,2,2);
			}			
			$this->tablealigns=array('C','L','L','L','R','R','R');			
			$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
			$this->tabletextcolor=array();			
			$RowArray = array(
				's0' => $i+1,
				's1' => $newDate,
				's2' => $aux,
				's3' => trim($datarow['glosa1'])."\r\n".trim($datarow['glosa']),
				's4' => $debe,
				's5' => $haber,
				's6' => $acreedor
			);
			
			$fill = !$fill;			
			//$acreedor=$debe+$haber;			
			$this->total = $this->total -1;
			
			$i++;		
			$this-> MultiRow($RowArray,$fill,0);			
			$this->revisarfinPagina($datarow);
			
		}			
		$this->cerrarCuadro();
		$this->cerrarCuadroTotal();			
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
	} 
	//desde generarcuerpo
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);
		$this->calcularMontos($a);			
		if ($startY > 250) {			
			$this->cerrarCuadro();
			$this->cerrarCuadroTotal();		
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
		$this->s3=$this->s1-$this->s2;
		
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
		$this->t3=$this->t1-$this->t2;			
	}	
	//revisarfinPagina pie
	function cerrarCuadro(){		
		/*
		if(($this->s1)<0){
			$this->s1=($this->s1)*-1;
			$this->s1= '('.(string)(number_format($this->s1, 2, '.', ',')).')';	
			$this->tablenumbers=array(0,0,0,0,0,2,2);
		}else{
			$this->tablenumbers=array(0,0,0,0,2,0,0);
		}
		if(($this->s2)<0){
			$this->s2=($this->s2)*-1;
			$this->s2= '('.(string)(number_format($this->s2, 2, '.', ',')).')';		
			$this->tablenumbers=array(0,0,0,0,2,0,2);
		}else{
			$this->tablenumbers=array(0,0,0,0,0,2,0);
		}
		if(($this->s3)<0){
			$this->s3=($this->s3)*-1;
			$this->s3= '('.(string)(number_format($this->s3, 2, '.', ',')).')';
			$this->tablenumbers=array(0,0,0,0,2,2,0);		
		}else{
			$this->tablenumbers=array(0,0,0,0,0,0,2);
		}	*/
		//si noes inicio termina el cuardro anterior
		$conf_par_tablewidths=array(7,15,50,60,20,20,20);			
		$this->tablealigns=array('R','R','R','R','R','R','R');		
		
		$this->tableborders=array('T','T','T','T','LRTB','LRTB','LRTB');						
		$RowArray = array(  's0' => '',
							's1' => '',
							's2' => '', 
							'espacio' => 'Subtotal',
							's3' => $this->s1,
							's4' => $this->s2,
							's5' => $this->s3
						);		
		$this-> MultiRow($RowArray,false,1);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->s5 = 0;
	}
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(7,15,50,60,20,20,20);					
		$this->tablealigns=array('R','R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,2,2,2);
		$this->tableborders=array('','','','','LRTB','LRTB','LRTB');									
		$RowArray = array(
					't0' => '', 
					't1' => '',
					't2' => '',
					'espacio' => 'TOTAL: ',
					't3' => $this->t1,
					't4' => $this->t2,
					't5' => $this->t3
				);
		$this-> MultiRow($RowArray,false,1);
	}
	
	function cab() {
		$var = array();
		$desc = array();
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"LIBRO MAYOR",0,1,'C');					
		$this->Ln(3);		
		
		if($this->objParam->getParametro('desde')!=null){
			$desde = $this->objParam->getParametro('desde');
			array_push($var,$desde);
			array_push($desc,'DESDE:');
			$cant++;	
		}
		if($this->objParam->getParametro('hasta')!=null){
			$hasta = $this->objParam->getParametro('hasta');
			array_push($var,$hasta);
			array_push($desc,'HASTA:');
			$cant++;	
		}
		if($this->objParam->getParametro('aux')!=null){
			$aux = $this->objParam->getParametro('aux');
			array_push($var,$aux);
			array_push($desc,'AUXILIAR:');
			$cant++;	
		}
		if($this->objParam->getParametro('gest')!=null){
			$gest = $this->objParam->getParametro('gest');
			array_push($var,$gest);
			array_push($desc,'GESTION:');
			$cant++;	
		}
		if($this->objParam->getParametro('depto')!=null){
			$depto = $this->objParam->getParametro('depto');
			array_push($var,$depto);
			array_push($desc,'DEPARTAMENTO:');
			$cant++;	
		}						
		if($this->objParam->getParametro('config_tipo_cuenta')!=null){
			$config_tipo_cuenta = $this->objParam->getParametro('config_tipo_cuenta');
			array_push($var,$config_tipo_cuenta);
			array_push($desc,'TIPO DE CUENTA:');
			$cant++;	
		}			
		if($this->objParam->getParametro('config_subtipo_cuenta')!=null){
			$config_subtipo_cuenta = $this->objParam->getParametro('config_subtipo_cuenta');
			array_push($var,$config_subtipo_cuenta);
			array_push($desc,'SUB TIPO DE CUENTA:');
			$cant++;	
		}				
		if($this->objParam->getParametro('cuenta')!=null){
			$cuenta = $this->objParam->getParametro('cuenta');
			array_push($var,$cuenta);
			array_push($desc,'CUENTA CONTABLE:');
			$cant++;	
		}
		if($this->objParam->getParametro('partidas')!=null){
			$partidas = $this->objParam->getParametro('partidas');
			array_push($var,$partidas);
			array_push($desc,'PARTIDA:');
			$cant++;	
		}
		if($this->objParam->getParametro('tipo_cc')!=null){
			$tipo_cc = $this->objParam->getParametro('tipo_cc');
			array_push($var,$tipo_cc);
			array_push($desc,'TIPO DE CENTRO DE COSTO:');
			$cant++;	
		}			
		if($this->objParam->getParametro('centro_costo')!=null){
			$centro_costo = $this->objParam->getParametro('centro_costo');
			array_push($var,$centro_costo);
			array_push($desc,'CENTRO DE COSTO:');
			$cant++;	
		}		
		if($this->objParam->getParametro('orden_trabajo')!=null){
			$orden_trabajo = $this->objParam->getParametro('orden_trabajo');
			array_push($var,$orden_trabajo);
			array_push($desc,'ORDEN DE TRABAJO:');
			$cant++;	
		}
		if($this->objParam->getParametro('suborden')!=null){
			$suborden = $this->objParam->getParametro('suborden');
			array_push($var,$suborden);
			array_push($desc,'SUBORDEN:');
			$cant++;	
		}
		if($this->objParam->getParametro('nro_tramite')!=null){
			$nro_tram = $this->objParam->getParametro('nro_tramite');
			array_push($var,$nro_tram);
			array_push($desc,'NRO TRAMITE:');
			$cant++;	
		}
		//				
		$height = 1;
		$width1 = 5;
		$esp_width = 5;
		$width_c1= 30;
		$width_c2= 50;	
		for($i=0;$i<=$cant;$i++){
			$this->SetFont('', 'B',6);
			$this->SetFillColor(192,192,192, true);
			if($i%2==0){
				$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
				$this->Cell($width_c1, $height, $desc[$i], 0, 0, 'L', false, '', 0, false, 'T', 'C');
				$this->SetFont('', '',6);				
				$this->Cell($width_c2, $height, $var[$i], 0, 0, 'L', true, '', 0, false, 'T', 'C');
			}else{
				$this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
				$this->Cell(30, $height,$desc[$i], 0, 0, 'L', false, '', 0, false, 'T', 'C');
				$this->SetFont('', '',6);
				$this->Cell(50, $height, $var[$i], 0, 0, 'L', true, '', 0, false, 'T', 'C');
				$this->Ln();
			}			
		}
					
		$this->Ln(4);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}	
}
?>