<?php
// Extend the TCPDF class to create custom MultiRow
class RTipoestadocuenta extends  ReportePDF {
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
	
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(20);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		$this->datos_tpoestado = $tpoestado;
		$this->datos_auxiliar = $auxiliar;
		$this->subtotal = 0;
		$this->SetMargins(20, 59, 5);
	}
	
	function Header() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"ESTADO DE CUENTAS",0,1,'C');					
		$this->Ln(3);
		$this->SetFont('','',10);
		$height = 5;
		$width1 = 5;
		$esp_width = 10;
		$width_c1= 30;
		$width_c2= 50;
		$width3 = 40;
		$width4 = 75;
		$width5 = 70;
		$width6 = 25;	
		
		$fecha_ini =$this->objParam->getParametro('desde');
		$fecha_fin = $this->objParam->getParametro('hasta');		
		///////////////////////////////////////////////
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'Del:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);			
		$this->Cell($width_c2, $height, $fecha_ini, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		///////////////////////////////////////////////			
		$this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height,'Hasta:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);			
		$this->Cell($width_c2, $height, $fecha_fin, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		//////////////////////////////////////////////		
		$this->Ln();
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'Auxiliar:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);
		$this->Cell($width_c2, $height,$this->datos_auxiliar['nombre_auxiliar'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
		//salto de linea
		$this->Ln();
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height,'Tipo de Estado:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);
		$this->Cell($width5, $height, $this->datos_tpoestado['nombre'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
		
		$this->Ln(10);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,50,80,15,15,15);
		$conf_par_tablealigns=array('C','C','C','C','C','C');
		$conf_par_tablenumbers=array(0,0,0,0,0,0);
		$conf_tableborders=array();
		$conf_tabletextcolor=array();		
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$RowArray = array(
				's0' => 'Nº',
				's1' => 'NOMBRE',
				's2' => 'DESCRIPCION',
				's3' => 'MONTO MB',
				's4' => 'MONTO MT'
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
		$this->Ln(4);
	}
	//		
	function generarCuerpo($detalle){
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
			
		$conf_par_tablewidths=array(7,50,80,15,15,15);
		$conf_par_tablealigns=array('C','L','L','C','C','C');
		$conf_par_tablenumbers=array(0,0,0,0,0,0);
		$conf_tableborders=array('LR','LR','LR','LR','LR','LR');		
		$RowArray = array(  's0' => $count,
							's1' => trim($val['nombre']),
							's2' => trim($val['descripcion']),
							's3' => $val['monto_mb'],
							's4' => $val['monto_mt']			
						);				
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$this->calcularMontos($val);		
		$this-> MultiRow($RowArray,$fill,0);
	}
	//desde generarcuerpo
	function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$x=0;
		$this->getNumLines($row['cell1data'], 80);

		if ($startY > 190) {
			$this->cerrarCuadro();
			$this->cerrarCuadroTotal();
			if($this->total!= 0){
				$this->AddPage();
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
		$this->s1 = $this->s1 + $val['monto_mb'];
		$this->s2 = $this->s2 + $val['monto_mt'];
					
		$this->t1 = $this->t1 + $val['monto_mb'];
		$this->t2 = $this->t2 + $val['monto_mt'];
	}	
	//revisarfinPagina pie
	function cerrarCuadro(){
		//si noes inicio termina el cuardro anterior
		$conf_par_tablewidths=array(7,50,80,15,15,15);				
		$this->tablealigns=array('R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,0,0);
		$this->tableborders=array('T','T','T','LRTB','LRTB','LRTB');						
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
	}
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(7,50,80,15,15,15);	
		$this->tablealigns=array('R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,0,0);
		$this->tableborders=array('','','','LRTB','LRTB','TRB');	
							
		$RowArray = array( 
					't1' => '',
					't2' => '',
					'espacio' => 'TOTAL: ',
					't3' => $this->t1,
					't4' => $this->t2
				);
		$this-> MultiRow($RowArray,false,1);
	}
}
?>