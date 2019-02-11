<?php
// Extend the TCPDF class to create custom MultiRow
class Rinvoice extends ReportePDF {
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
	var $s7;
	
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
	var $factura;
	
	function datosHeader ($detalle) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		$this->SetMargins(10, 15, 5,10);
	}

	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,15,25,45,20,25,15,15,20,15);
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0); //coloca si una celda es numero= 2 o texto = 0
		$conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C');
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
							's1' => 'Fecha Factura:',
							's2' => 'Nro Factura:',
							's3' => 'Razon Social:',
							's4' => 'Importe de Factura:',
							//'s5' => 'Moneda:',
							's5' => 'Importe Descuento Ley:',
							//'s7' => 'Moneda:',
							's6' => 'Liquido:',
							's7' => 'Moneda:',
		
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//
	function generarReporte($detalle) {
		$this->factura = $detalle;
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->factura);
	}
	//		
	function generarCuerpo($detalle){		
		//function
		$this->cab($detalle);
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
		$var='';
		$sw="0";
		
		$primero=0;
		$conteoFactura=0;
		//var_dump($this->factura);
		$primero= 0;
		foreach ($this->factura as $datarow) {
			//var_dump($datarow); 
						
						$this->tablealigns=array('C','L','L','L','R','R','R','R','R','R');	// las alings de las tablas center left right		
						$this->tableborders=array('RLT','RLT','RLT','RLT','RLT','RLT','RLT','RLT','RLT','RLT'); // los bordes de la tabla right left top botton
						$this->tabletextcolor=array();	
						
						$RowArray = array(
							's0' =>$i+1,
							's1' =>trim($datarow['fecha']),
							//'s1' =>date("d-m-Y", strtotime(trim($datarow['fecha']))),
							's2' =>trim($datarow['nro_documento']),
							's3' =>trim($datarow['razon_social']),
							's4' =>trim(number_format($datarow['importe_doc'], 2, '.', ',')),
							//'s5' =>trim($datarow['desc_moneda']),
							's5' =>trim(number_format($datarow['importe_descuento_ley'], 2, '.', ',')),
							//'s7'=>trim($datarow['desc_moneda']),
							's6' =>trim(number_format($datarow['importe_pago_liquido'], 2, '.', ',')),
							's7' =>	trim($datarow['desc_moneda']),	
						);
						$fill = !$fill;					
						$this->total = $this->total -1;			
						$i++;		
						$this-> MultiRow($RowArray,$fill,0);			
									

			$this->revisarfinPagina($datarow);
		}
		//$this->cerrarCuadro();		
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
		//$this->calcularMontos($a);			
		if ($startY > 235) {			
			$this->cerrarCuadro();	
		//$this->cerrarCuadroTotal();	//cuanto se usa total	
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
		//var_dump($val['importe_doc']);
		
		$this->s1 = $this->s1 + $val['importe_doc'];
		$this->s2 = $this->s2 + $val['importe_descuento_ley'];
		$this->s3 = $this->s3 + $val['importe_pago_liquido'];					
		$this->t1=$this->t1+$val['importe_doc'];			
		$this->t2=$this->t2+$val['importe_descuento_ley'];
		$this->t3=$this->t3+$val['importe_pago_liquido'];
	}
	//revisarfinPagina pie
	function cerrarCuadro(){		
		
		
		$conf_par_tablewidths=array(7,15,15,30,15,25,15,20,20);					
		$this->tablealigns=array('R','L','L','R','R','R','R','R','R');	
		//$this->tablenumbers=array(0,0,0,2,0,0,2,2);
		$this->tableborders=array('T','T','T','T','T','T','T','T');	
		
		$this->s1= ''.(string)(number_format($this->s1, 2, '.', ',')).'';	
		$this->s2= ''.(string)(number_format($this->s2, 2, '.', ',')).'';
		$this->s3= ''.(string)(number_format($this->s3, 2, '.', ',')).'';						
		$RowArray = array(  
							's0' => '', 
							's1' => '',
							//'espacio' => 'Subtotal Facturado: ',
							's2' => '',
							's3' => '',
							's4' => '',
							//'espacio1' => 'Subtotales: ',
							's5' => '',
							's6' => '',
							's7' => '',
							
							
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
		
		$conf_par_tablewidths=array(7,15,15,30,20,25,15,20,20);					
		$this->tablealigns=array('R','R','L','R','R','R','R','R','R');	
		//$this->tablenumbers=array(0,0,0,0,0,2,0,2,2);
		$this->tableborders=array('T','T','T','T','T','T','T','T');//dibuja las celdas q se habbilitan en el total
		
		//$this->t1= ''.(string)(number_format($this->t1, 2, '.', ',')).'';	
		//$this->t2= ''.(string)(number_format($this->t2, 2, '.', ',')).'';
		//$this->t3= ''.(string)(number_format($this->t3, 2, '.', ',')).'';	
		  
		 
		 /*
		if(($this->t3)<0){
			$this->t3=($this->t3)*-1;
			$this->t3= '('.(string)(number_format($this->t3, 2, '.', ',')).')';
			$this->tablenumbers=array(0,0,0,0,2,2,0);		
		}else{
			$this->tablenumbers=array(0,0,0,0,0,0,2);
		}	*/							
		$RowArray = array(
					't0' => '', 
					't1' => '',
					't2' => '',
					//'espacio' => 'Totales: ',
					't3' => '',
					't4' => '',
					't5' => '',
					't6' => '',
					't7' => '',
					
				);
		$this-> MultiRow($RowArray,false,1);
	}
	
	function cab($detalle) {
		$datos=$detalle;
		$var = array();
		$desc = array();
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"INVOICE (EXTERIOR - IUE/BE)",0,1,'C');					
		$this->Ln(8);	
		
		//Cell($w, $h=0, $txt='', $border=0, $ln=0, $align='', $fill=0, $link='', $stretch=0, $ignore_min_height=false, $calign='T', $valign='M')
	
		//coloca los datos del cliente en la cabecera 
		/*
		if($this->objParam->getParametro('razon_social')!=null){
			$razon_social = $this->objParam->getParametro('razon_social');
			$nit=$datos[0]['nit'];
			array_push($var,$razon_social);
			array_push($var,$nit);
			array_push($desc,'Razon Social:');
			array_push($desc,'Nit:');
			$cant++;	
		}*/
		//		
		/*		
		$height = 1;
		$width1 = 5;
		$esp_width = 5;
		$width_c1= 30;
		$width_c2= 50;	
		
		for($i=0;$i<=$cant;$i++){
			$this->SetFont('', 'B',6);
			$this->SetFillColor(192,192,192, false);
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
		}*/
					
		$this->Ln(4);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}	
}
?>