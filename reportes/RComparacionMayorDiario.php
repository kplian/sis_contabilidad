<?php
// Extend the TCPDF class to create custom MultiRow
class RComparacionMayorDiario extends  ReportePDF {
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
	
	
	
	function datosHeader ( $detalle, $totales,$entidad, $periodo) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $entidad;
		$this->datos_periodo = $periodo;
		$this->subtotal = 0;
		$this->SetMargins(20, 59, 5);
		//$this->SetMargins(10, 59, 5);
	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		
		
	    $this->SetFont('','B',12);		
		$this->Cell(0,5,"DIFERENCIA LIBRO MAYOR Y LIBRO DIARIO",0,1,'C');		
		//$this->Ln();
		$this->SetFont('','B',7);
		$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(2);
		
		$this->SetFont('','',10);
		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 112;
        $width3 = 40;
        $width4 = 75;
		
		if($this->objParam->getParametro('filtro_sql') == 'fechas'){
			
			$fecha_ini =$this->objParam->getParametro('fecha_ini');
		    $fecha_fin = $this->objParam->getParametro('fecha_fin');
		
		
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'DEL:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell($width_c2, $height, $fecha_ini, 0, 0, 'L', true, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'Haste:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell(50, $height, $fecha_fin, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		}
		else{
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'Año:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->Cell($width_c2, $height, $this->datos_periodo['gestion'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'Mes:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->Cell(50, $height, $this->datos_periodo['literal_periodo'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
		}
		
		
		$this->Ln();
		
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'Nombre o Razón Social:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->datos_entidad['nombre'].' ('.$this->datos_entidad['direccion_matriz'].')', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell(20, $height,'NIT:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell(50, $height, $this->datos_entidad['nit'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
		$this->Ln(19);
	
		
		$this->SetFont('','B',6);
		$this->generarCabecera();
		
		
	}
	
	function Footer() {
		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
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
		//$this->Ln();
		//$barcode = $this->getBarcode();
		/*$style = array(
					'position' => $this->rtl?'R':'L',
					'align' => $this->rtl?'R':'L',
					'stretch' => false,
					'fitwidth' => true,
					'cellfitalign' => '',
					'border' => false,
					'padding' => 0,
					'fgcolor' => array(0,0,0),
					'bgcolor' => false,
					'text' => false,
					'position' => 'R'
				);*/
        //$this->write1DBarcode($barcode, 'C128B', $ancho*2, $cur_y + $line_width+5, '', (($this->getFooterMargin() / 3) - $line_width), 0.3, $style, '');
				
	
	}
	
   
   function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
	    $sw = false;
		$concepto = '';
		
		$this->generarCuerpo($this->datos_detalle);
		
		if($this->s1 != 0){
			$this->SetFont('','B',6);
			$this->cerrarCuadro();	
			// para el ultimo
		    //$this->cerrarCuadroTotal();
		}
		
		$this->Ln(4);
		
		
	} 
    function generarCabecera(){
    	
		
		
		//arma cabecera de la tabla  17  - 13   20   -    ;  (15,  14  21,   2,,4,6)
		$conf_par_tablewidths=array(10,35,30,30,35,30,30,30);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0);

        $conf_tableborders=array();
        $conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		

		$RowArray = array(
				's0' => 'Nº',
				's1' => 'NRO COMPROBANTE MAYOR',    //ingreso_inicial
				's2' => "IMPORTE DEBE MAYOR",        //ingreso_colectas
				's3' => 'DIFERENCIA',           //ingreso_traspasos
				's4' => 'NRO COMPROBANTE LIBRO DE COMPRAS',
				's5' => 'TOTAL CREDITO FISTAL COMPRAS',   //egreso_inicial_por_rendir
				's6' => "ID COMPROBANTE",
				's7' => "USUARIO");
		

		$this->MultiRow($RowArray, false, 1);
    }
	
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
		$this->s6 = 0;
        //$this->Cell(20, $height,'NIT:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		foreach ($detalle as $val) {
			
			if($val['importe_debe_mb_mayor']== '0.00' && $val['tota_credito_fiscal_compras'] == '0.00' ){

			}
			else{
						$this->imprimirLinea($val,$count,$fill);
						//$fill = !$fill;
						$count = $count + 1;
						$this->total = $this->total -1;
						$this->revisarfinPagina();
			}
									

		}
	}	
	
	function imprimirLinea($val,$count,$fill){
		

		
		if((float)$val['diferencia'] != (float)'0.00' ){
			 $dif=0.00;
			if((float)$val['diferencia'] > 0){
				$dif=(float)$val['diferencia'];
			}
			if((float)$val['diferencia'] < 0){
				$dif=(float)$val['diferencia']*-1;
			}
			
			if($dif>0.20){
	            $fill = !$fill;
				$this->SetFillColor(254, 56, 56);
	            $this->SetTextColor(0);
	            $this->SetFont('','',6);
			}
			else{
				$fill = !$fill;
				$this->SetFillColor(224, 235, 255);
	            $this->SetTextColor(0);
	            $this->SetFont('','',6);
			}
			
		//	var_dump($val['diferencia'].' rojo');
		}
		else{
			$fill = !$fill;
			$this->SetFillColor(224, 235, 255);
            $this->SetTextColor(0);
            $this->SetFont('','',6);
			//var_dump($val['diferencia'].'  otro');
		}	
		//var_dump($val['diferencia']);

		   
		//$conf_par_tablewidths=array(7,15,15,38,14,12,21);
	    $conf_par_tablewidths=array(10,35,30,30,35,30,30,30);
        $conf_par_tablealigns=array('C','C','R','L','R','R','R','R');
        $conf_par_tablenumbers=array(0,0,2,2,0,2,0,0);
		$conf_tableborders=array('LR','LR','LR','LR','LR','LR','LR','LR');
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$this->caclularMontos($val);
		
		//$newDate = date("d/m/Y", strtotime( $val['fecha']));
       
		$RowArray = array(
            			's0'  => $count,
                        's1' => trim($val['nro_cbte_mayor']),
                        's2' => trim($val['importe_debe_mb_mayor']),
						's3' => trim($val['diferencia']),
                        's4' => trim($val['nro_cbte_compras']),
                        's5' => $val['tota_credito_fiscal_compras'] ,
                        's6' => $val['id_int_comprobante'],
                        's7' => trim($val['cuenta'])
						);
		

		$this-> MultiRow($RowArray,$fill,0);
			
	}


    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		/*if (($startY + 4 * 6) + $dimensions['bm'] > ($dimensions['hk'])) {
		    	
			$this->cerrarCuadro();	
			$this->cerrarCuadroTotal();
			$k = 	($startY + 4 * 6) + $dimensions['bm'] - ($dimensions['hk']);

			
			if($this->total!= 0){
				$this->AddPage();
			}
			
			
		    
		} */

        if ($startY > 190) {

            $this->cerrarCuadro();
            //$this->cerrarCuadroTotal();

            if($this->total!= 0){
                $this->AddPage();
            }

        }


    }
	
	
	
	function caclularMontos($val){
		
		

			//$this->s1 = $this->s1 + ($val['nro_cbte_mayor'] );
			$this->s1 = $this->s1 + ($val['importe_debe_mb_mayor'] );
			$this->s2 = $this->s2 + ($val['diferencia'] );
			//$this->s3 = $this->s3 + 0;
			$this->s4 = $this->s4 + ($val['tota_credito_fiscal_compras']);
			//$this->s6 = $this->s6 + ($val['id_int_comprobante'] );
			$this->t1 = $this->t1 + ($val['importe_debe_mb_mayor'] );
			$this->t2 = $this->t2 + ($val['diferencia'] );
			//$this->s3 = $this->s3 + 0;
			$this->t4 = $this->t4 + ($val['tota_credito_fiscal_compras']);
		
	}
  function cerrarCuadro(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
				
	   	    $this->tablewidths=array(7 +20 +18,30,30,35,30);
	        $this->tablealigns=array('R','R','R','R');
	        $this->tablenumbers=array(0,2,2,0,0,2);	
	        $this->tableborders=array('T','LRTB','LRTB','LRTB');				

	        
	        $RowArray = array( 
	                    'espacio' => 'Total: ', // 'esto es Sub total' => 'Total: ',
	               //     's1' => $this->s1,
	                    's1' => $this->s1,
	                    's2' => $this->s2,
	                    's3' => '',
	                    's4' => $this->s4,
	                    //'s6' => $this->s6,
	                    //'s7' => '',
	                    //'s8' => ''
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
			
			/*$this->s1 = 0;
			$this->s2 = 0;
			$this->s3 = 0;
			$this->s4 = 0;*/

	
  }

  function cerrarCuadroTotal(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
				
			$this->tablewidths=array(7 +20 +18,30,30,35,30);
	        $this->tablealigns=array('R','R','R','R');
	        $this->tablenumbers=array(0,2,2,0,0,2);	
	        $this->tableborders=array('','LRTB','LRTB','LRTB');				

	        $RowArray = array( 
	                    'espacio' => 'TOTAL: ',
	                    't1' => $this->t1,
	                    't2' => $this->t2,
	                    't3' => '',
	                    
	                    't4' => $this->t4,
	                    //'t6' => $this->t6
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
			
				
			$this->t1 = 0;
			$this->t2 = 0;
			//$this->t3 = 0;
			$this->t4 = 0;
	
  }
  
 
}
?>