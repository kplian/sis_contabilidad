<?php
class REntregaXls
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();
	
	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
	private $objParam;
	public  $url_archivo;
	
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $t1;
	var $tg1;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $ult_codigo_partida;
	var $ult_concepto;	
	
	
	
	function __construct(CTParametro $objParam){
		$this->objParam = $objParam;
		$this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
		//ini_set('memory_limit','512M');
		set_time_limit(400);
		$cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
		$cacheSettings = array('memoryCacheSize'  => '10MB');
		PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

		$this->docexcel = new PHPExcel();
		$this->docexcel->getProperties()->setCreator("PXP")
							 ->setLastModifiedBy("PXP")
							 ->setTitle($this->objParam->getParametro('titulo_archivo'))
							 ->setSubject($this->objParam->getParametro('titulo_archivo'))
							 ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
							 ->setKeywords("office 2007 openxml php")
							 ->setCategory("Report File");
							 
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('titulo_archivo'));
		
		$this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
								9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
								18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
								26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
								34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
								42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
								50=>'AY',51=>'AZ',
								52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
								60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
								68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
								76=>'BY',77=>'BZ');		
									
	}
	
	function datosHeader ( $detalle, $id_entrega) {
		
		$this->datos_detalle = $detalle;
		$this->id_entrega = $id_entrega;
		
	}
	
	function ImprimeCabera(){
		
	}
			
	function imprimeDatos(){
		$datos = $this->datos_detalle;
		$config = $this->objParam->getParametro('config');
		$columnas = 0;
		
		$styleTitulos = array(
							      'font'  => array(
							          'bold'  => true,
							          'size'  => 8,
							          'name'  => 'Arial'
							      ),
							      'alignment' => array(
							          'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
							          'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
							      ),
								   'fill' => array(
								      'type' => PHPExcel_Style_Fill::FILL_SOLID,
								      'color' => array('rgb' => 'c5d9f1')
								   ),
								   'borders' => array(
								         'allborders' => array(
								             'style' => PHPExcel_Style_Border::BORDER_THIN
								         )
								     ));
									 
									 
       $inicio_filas = 7;
       $this->docexcel->getActiveSheet()->getStyle('A7:H7')->applyFromArray($styleTitulos);
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[0])->setWidth(20);		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_filas,'Clase de Gasto');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[1])->setWidth(25);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$inicio_filas,'Categoria Prog.');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[2])->setWidth(40);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$inicio_filas,'Partida');		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[3])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$inicio_filas,'Importe');		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$inicio_filas,'Importe Doc.');		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(10);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$inicio_filas,'ID Cbte');		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[6])->setWidth(30);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$inicio_filas,'Concepto');		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[7])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$inicio_filas,'Beneficiario');		
		
		//*************************************Fin Cabecera*****************************************
		
		$fila = $inicio_filas+1;
		$contador = 1;
		$sw = true;
		
		$fila_ini = $fila;
		$fila_fin = $fila;
		$fila_ini_par = $fila;
		$fila_fin_par = $fila;
		$fila_ini_cg = $fila;
		$fila_fin_cg = $fila;
		
		$sumatoria = 0;
		$sumatoria_neto = 0;
		$sumatoria_par = 0;
		$sumatoria_neto_par = 0;
		$sumatoria_cg = 0;
		$sumatoria_neto_cg = 0;
		
		//EStilos para categorias programaticas
		$styleArrayGroup = array(
							    'font'  => array('bold'  => true),
							     'alignment' => array('horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
												       'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER),
								 'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,'color' => array('rgb' => 'FFCCFF')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								     
								 );
						   
		$styleArrayTotal = array(
							    'font'  => array('bold'  => true),
							    'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,
											    'color' => array('rgb' => 'FFCCFF')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								);	
								
		//Estilos para partidas						
		$styleArrayGroupPar = array(
							     'font'  => array('bold'  => true),
							     'alignment' => array('vertical' => PHPExcel_Style_Alignment::VERTICAL_TOP),
								 'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,'color' => array('rgb' => '33FF66')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								 );
						   
		$styleArrayTotalPar = array(
							    'font'  => array('bold'  => true),
							    'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,
											    'color' => array('rgb' => '33FF66')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								);	
								
		//Estilos para CLASES DE GASTO						
		$styleArrayGroupCg = array(
							     'font'  => array('bold'  => true),
							     'alignment' => array('horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
												       'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER),
								 'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,'color' => array('rgb' => 'FFFF99')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								 );
						   
		$styleArrayTotalCg = array(
							    'font'  => array('bold'  => true),
							    'fill' => array('type' => PHPExcel_Style_Fill::FILL_SOLID,
											    'color' => array('rgb' => 'FFFF99')),
								 'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
								);								
		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $value) {
		    
			
			if($value['importe_gasto_mb'] > 0){
				$importe_neto = $value['importe_gasto_mb'];
				$importe = $value['importe_debe_mb_completo'];
			}
			else{
				$importe_neto = $value['importe_recurso_mb'];
				$importe = $value['importe_haber_mb_completo'];
			}
			
			 $importe_neto = round ($importe_neto,2);
			 $importe = round ($importe,2);
			 
			
			//validamos agrupadores
			if($sw){
				$sw = false;
				$tmp_rec = $value;
			}
			else{
				
				//revisiond e aprtida
                if($tmp_rec['codigo'] != $value['codigo']){
					//si la categoria es distinta insertamos fila agrupadora
					
					//insertamos fila de sumatoria
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto_par);
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria_par);
					$fila_fin_par = $fila;
					
					//agrupamos celdas inicial y final
					$this->docexcel->setActiveSheetIndex(0)->mergeCells("C".($fila_ini_par).":C".($fila_fin_par));
					//Dar formato a las celdas tolizadoras
					$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_ini_par).":C".($fila_fin_par))->applyFromArray($styleArrayGroupPar);
					$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_fin_par).":H".($fila_fin_par))->applyFromArray($styleArrayTotalPar);
					$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_ini_par).":C".($fila_fin_par))->getAlignment()->setWrapText(true);
					
					//definir agrupador de filas
					for ($row = $fila_ini_par; $row <= $fila_fin_par-1; ++$row) {
						$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(1)->setVisible(false)->setCollapsed(true);
					}
					$fila++;
			        $contador++;
					
					//reiniciamos agrupadores de celda
					$fila_fin_par = $fila;
					$fila_ini_par = $fila;
					$sumatoria_par = 0;
		            $sumatoria_neto_par = 0;
					
					
				}

				//REVISION DE CATEGORIA PROGRAMATICA
				if($tmp_rec['codigo_categoria'] != $value['codigo_categoria']){
					//si la categoria es distinta insertamos fila agrupadora					
					//insertamos fila de sumatoria
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto);
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria);
					
					
					$fila_fin = $fila;					
					//agrupamos celdas inicial y final					
					$this->docexcel->setActiveSheetIndex(0)->mergeCells("B".($fila_ini).":B".($fila_fin));
					//Dar formato a las celdas tolizadoras
					$this->docexcel->setActiveSheetIndex(0)->getStyle("B".($fila_ini).":B".($fila_fin))->applyFromArray($styleArrayGroup);
					$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_fin).":H".($fila_fin))->applyFromArray($styleArrayTotal);
					//definir agrupador de filas
					for ($row = $fila_ini; $row <= $fila_fin-1; ++$row) {
						//$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(2)->setVisible(true)->setCollapsed(true);
					}
					
					$fila++;
			        $contador++;
					//reiniciamos agrupadores de celda
					$fila_fin = $fila;
					$fila_ini = $fila;
					$sumatoria = 0;
		            $sumatoria_neto = 0;
					
					//SI cerramos un categoria iniciamos tambien las partida
					//reiniciamos agrupadores de celda
					$fila_fin_par = $fila;
					$fila_ini_par = $fila;
					$sumatoria_par = 0;
		            $sumatoria_neto_par = 0;
				}
      
                //////////////////////////////
				//REVISION DE CLASE DE GASTO
				//////////////////////////////////
				if($tmp_rec['codigo_cg'] != $value['codigo_cg']){
					//si la categoria es distinta insertamos fila agrupadora					
					//insertamos fila de sumatoria
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto_cg);
					$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria_cg);
					
					
					$fila_fin_cg = $fila;					
					//agrupamos celdas inicial y final					
					$this->docexcel->setActiveSheetIndex(0)->mergeCells("A".($fila_ini_cg).":A".($fila_fin_cg));
					//Dar formato a las celdas tolizadoras
					$this->docexcel->setActiveSheetIndex(0)->getStyle("A".($fila_ini_cg).":A".($fila_fin_cg))->applyFromArray($styleArrayGroupCg);
					$this->docexcel->setActiveSheetIndex(0)->getStyle("A".($fila_fin_cg).":H".($fila_fin_cg))->applyFromArray($styleArrayTotalCg);
					
					//definir agrupador de filas
					for ($row = $fila_ini_cg; $row <= $fila_fin_cg-1; ++$row) {
						//$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(3)->setVisible(true)->setCollapsed(true);
					}
					$fila++;
			        $contador++;
					//reiniciamos agrupadores de celda
					$fila_fin_cg = $fila;
					$fila_ini_cg = $fila;
					$sumatoria_cg = 0;
		            $sumatoria_neto_cg = 0;
					
					//SI cerramos un categoria iniciamos tambien las partida
					//reiniciamos agrupadores de celda
					$fila_fin_par = $fila;
					$fila_ini_par = $fila;
					$sumatoria_par = 0;
		            $sumatoria_neto_par = 0;
					//reiniciamos las categorias porgramticas
					$fila_fin_ = $fila;
					$fila_ini = $fila;
					$sumatoria = 0;
		            $sumatoria_neto = 0;
				}

                

			}

			$sumatoria = $sumatoria + $importe;
			$sumatoria_neto = $sumatoria_neto + $importe_neto;
			
			$sumatoria_par = $sumatoria_par + $importe;
			$sumatoria_neto_par = $sumatoria_neto_par + $importe_neto;
			
			$sumatoria_cg = $sumatoria_cg + $importe;
			$sumatoria_neto_cg = $sumatoria_neto_cg + $importe_neto;
			
			
							
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$value['codigo_cg'].'-'.$value['nombre_cg']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['codigo_categoria']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['codigo'].'-'.$value['nombre_partida']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$importe_neto);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$importe);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['id_int_comprobante_dev']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$value['glosa1']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,$value['beneficiario']);
						
			//$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(14,$fila,"=SUM(C".$fila.":N".$fila.")");
			
			if(!$sw){
				$tmp_rec = $value;
			}
			
			$fila++;
			$contador++;
		}
		//************************************************Fin Detalle***********************************************
		////////////////////////
		//PARA PARTIDAS
		/////////////////////
		
		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto_par);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria_par);
		$fila_fin_par = $fila;		
		//agrupamos celdas inicial y final
		$this->docexcel->setActiveSheetIndex(0)->mergeCells("C".($fila_ini_par).":C".($fila_fin_par-1));
		//Dar formato a las celdas tolizadoras
		$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_ini_par).":C".($fila_fin_par))->applyFromArray($styleArrayGroupPar);
		$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_fin_par).":H".($fila_fin_par))->applyFromArray($styleArrayTotalPar);
		$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_ini_par).":C".($fila_fin_par))->getAlignment()->setWrapText(true);
					
		for ($row = $fila_ini_par; $row <= $fila_fin_par-1; ++$row) {
			$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(3)->setVisible(false)->setCollapsed(true);
		}
		$fila++;
        $contador++;
		
		//reiniciamos agrupadores de celda
		$fila_fin_par = $fila;
		$fila_ini_par = $fila;
					
			
		/////////////////////////////			
		//CATEGORIA PROGRAMATICA
		////////////////////////////
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,'TOTAL');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria);
		$fila_fin = $fila;
		//agrupamos celdas inicial y final
		$this->docexcel->setActiveSheetIndex(0)->mergeCells("B".($fila_ini).":B".($fila_fin-1));
		//Dar formato a las celdas tolizadoras
		$this->docexcel->setActiveSheetIndex(0)->getStyle("B".($fila_ini).":B".($fila_fin))->applyFromArray($styleArrayGroup);
		$this->docexcel->setActiveSheetIndex(0)->getStyle("C".($fila_fin).":H".($fila_fin))->applyFromArray($styleArrayTotal);
		//definir agrupador de filas
		for ($row = $fila_ini; $row <= $fila_fin-1; ++$row) {
			//$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(1)->setVisible(true)->setCollapsed(true);
		}
		$fila++;
        $contador++;
		
		///////////////////////////////
		//CERRAMOS LAS CLASES DE GASTO
		////////////////////////////////
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,'TOTAL');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$sumatoria_neto_cg);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$sumatoria_cg);
		$fila_fin_cg = $fila;					
		//agrupamos celdas inicial y final					
		$this->docexcel->setActiveSheetIndex(0)->mergeCells("A".($fila_ini_cg).":A".($fila_fin_cg-1));
		//Dar formato a las celdas tolizadoras
		$this->docexcel->setActiveSheetIndex(0)->getStyle("A".($fila_ini_cg).":A".($fila_fin_cg))->applyFromArray($styleArrayGroupCg);
		$this->docexcel->setActiveSheetIndex(0)->getStyle("A".($fila_fin_cg).":H".($fila_fin_cg))->applyFromArray($styleArrayTotalCg);
		for ($row = $fila_ini_cg; $row <= $fila_fin_cg-1; ++$row) {
		//	$this->docexcel->setActiveSheetIndex(0)->getRowDimension($row)->setOutlineLevel(1)->setVisible(true)->setCollapsed(true);
		}
		
		
		
		//ajustar testo en beneficiario y glosa
		$this->docexcel->setActiveSheetIndex(0)->getStyle("G".($inicio_filas).":H".($fila+1))->getAlignment()->setWrapText(true);

	}

      function imprimeTitulo($sheet){
		$titulo = "REporte de Entrega";
		$fechas = 'Del '.$this->objParam->getParametro('fecha_c31');
		
		
		
		//$sheet->setCellValueByColumnAndRow(0,1,$this->objParam->getParametro('titulo_rep'));
		$sheet->getStyle('A1')->getFont()->applyFromArray(array('bold'=>true,
															    'size'=>12,
															    'name'=>Arial));
																
		$sheet->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,1,strtoupper($titulo));		
		$sheet->mergeCells('A1:D1');
		
		//DEPTOS TITLE
		$sheet->getStyle('A2')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>Arial));	
																															
		$sheet->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,2,strtoupper("ID ".$this->objParam->getParametro('id_entrega')));		
		$sheet->mergeCells('A2:D2');
		//FECHAS
		$sheet->getStyle('A3')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>Arial));	
																															
		$sheet->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,3,$fechas);		
		$sheet->mergeCells('A3:D3');
		
	}

	
	
	function generarReporte(){
		
		
		$this->imprimeTitulo($this->docexcel->setActiveSheetIndex(0));		
		$this->imprimeDatos();
		
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);		
		
		
	}	
	

}

?>