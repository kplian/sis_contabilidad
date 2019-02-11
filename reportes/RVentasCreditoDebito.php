<?php
// Extend the TCPDF class to create custom MultiRow
class RVentasCreditoDebito extends ReportePDF {
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
	
	function datosHeader ($detalle,$entidad,$periodo) {
		//var_dump($detalle);
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_entidad = $entidad;
		$this->datos_periodo = $periodo;
		$this->SetMargins(10, 15, 5,10);
	}

	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,15,15,22,15,60,15,15,22,16,16,22,16);
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0); 
		$conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$valor=$a;
		$var = $this->objParam->getParametro('tipo_moneda');
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'FECHA NOTA DE CREDITO-DEBITO',
							's2' => 'Nº DE NOTA DE CREDITO-DEBITO',
							's3' => 'Nº DE AUTORIZACION',
							's4' => 'NIT PROVEEDOR',							
							's5' => 'NOMBRE O RAZON SOCIAL PROVEEDOR',
							's6' => 'IMPORTE TOTAL DE LA DEVOLUCION O RESCICION EFECTUADA A',
							's7' => 'DEBITO FISCAL B=A*13%',
							's8' => 'CODIGO DE CONTROL DE LA NOTA DE CREDITO - DEBITO',
							's9' => 'FECHA FACTURA ORIGINAL',
							's10' => 'Nº FACTURA ORIGINAL',
							's11' => 'Nº DE AUTORIZACION FACTURA ORIGINAL',
							's12' => 'IMPORTE TOTAL FACTURA ORIGINAL',		
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
		//var_dump($this->datos_detalle);
		$primero= 0;
		foreach ($this->datos_detalle as $datarow) {						
			$this->tablealigns=array('C','L','L','L','R','R','R','R','R','R','R','R','R');	// las alings de las tablas center left right		
			$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB'); 
			$this->tabletextcolor=array();	
			
			$RowArray = array(
				's0' =>$i+1,
				's1' =>trim($datarow['fecha']),
				's2' =>trim($datarow['nro_documento']),
				's3' =>trim($datarow['nro_autorizacion']),
				's4' =>trim($datarow['nit']),							
				's5' =>trim($datarow['razon_social']),							
				's6' =>0,
				's7' =>$datarow['importe_pago_liquido']*0.13,	
				's8' =>trim($datarow['codigo_control']),
				's9' =>	trim($datarow['fecha']),						
				's10' =>trim($datarow['nro_documento']),							
				's11' =>trim($datarow['nro_autorizacion']),
				's12' =>trim($datarow['importe_pago_liquido']),					
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
		
		
		$conf_par_tablewidths=array(7,15,15,22,15,60,15,15,22,16,16,22,16);					
		$this->tablealigns=array('R','L','L','R','R','R','R','R','R');	
		//$this->tablenumbers=array(0,0,0,2,0,0,2,2);
		$this->tableborders=array('T','T','T','T','T','T','T','T','T','T','T');	
		
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
		
		$conf_par_tablewidths=array(7,15,15,22,15,60,15,15,22,16,16,22,16);					
		$this->tablealigns=array('R','R','L','R','R','R','R','R','R');	
		//$this->tablenumbers=array(0,0,0,0,0,2,0,2,2);
		$this->tableborders=array('T','T','T','T','T','T','T','T');//dibuja las celdas q se habbilitan en el total
						
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
		$this->Cell(0,5,"LIBRO DE COMPRAS",0,1,'C');					
		$this->Ln(2);		
		$this->Cell(0,5,"PARA NOTAS DE CREDITO / DEBITO ",0,1,'C');					
		$this->Ln(8);	
		
					
		$this->Ln(4);
		$this->SetFont('','B',5);
		$this->generarCabecera();
	}	
}
?>