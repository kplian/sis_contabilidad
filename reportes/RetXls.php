<?php
 
class RetXls
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;
	var $liquido;
	var $descuento;
	var $importe;
	var $fila1;
	function __construct(CTParametro $objParam)
	{
		$this->objParam = $objParam;
		$this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
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
		$this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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
	function imprimeCabecera($shit,$tipo) {
		$datos = $this->objParam->getParametro('datos');

        $this->docexcel->createSheet($shit);
        $this->docexcel->setActiveSheetIndex($shit);
        $this->docexcel->getActiveSheet()->setTitle($tipo);
	
		$styleTitulos2 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 12,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '707A82'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		//
		if($shit==1){
			$this->docexcel->getActiveSheet()->getStyle('D1:J1')->applyFromArray($styleTitulos3);				
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'TOTALES DE LIBRO DE RETENCIONES');	
		}else{
			$tipo =$this->objParam->getParametro('tipo_ret');		
			switch ($tipo) {
				case 'todo':				
					$this->docexcel->getActiveSheet()->getStyle('E1:G1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'LIBRO DE RETENCIONES');						
					$this->docexcel->getActiveSheet()->getStyle('A2:P2')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getStyle('A3:P3')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(80);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(18);			
					//*************************************Cabecera************************//
					$this->docexcel->getActiveSheet()->getStyle('A2:P2')->getAlignment()->setWrapText(true);
					$this->docexcel->getActiveSheet()->getStyle('A3:P3')->getAlignment()->setWrapText(true);
					 
					$this->docexcel->getActiveSheet()->mergeCells('A2:A3');
					$this->docexcel->getActiveSheet()->mergeCells('B2:B3');
					$this->docexcel->getActiveSheet()->mergeCells('C2:C3');
					$this->docexcel->getActiveSheet()->mergeCells('D2:D3');
					$this->docexcel->getActiveSheet()->mergeCells('E2:E3');
					$this->docexcel->getActiveSheet()->mergeCells('F2:F3');
					$this->docexcel->getActiveSheet()->mergeCells('G2:G3');
													
					$this->docexcel->getActiveSheet()->mergeCells('N2:N3');
					$this->docexcel->getActiveSheet()->mergeCells('O2:O3');				
					$this->docexcel->getActiveSheet()->mergeCells('P2:P3');
									
					$this->docexcel->getActiveSheet()->mergeCells('H2:I2');
					$this->docexcel->getActiveSheet()->mergeCells('J2:K2');
					$this->docexcel->getActiveSheet()->mergeCells('L2:M2');
	
					$this->docexcel->getActiveSheet()->setCellValue('H2','BIENES');
					$this->docexcel->getActiveSheet()->setCellValue('J2','SERVICIOS');
					$this->docexcel->getActiveSheet()->setCellValue('L2','ALQUILERES');
						
					$this->docexcel->getActiveSheet()->setCellValue('A2','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B2','FECHA DE LA FACTURA O DUI');
					$this->docexcel->getActiveSheet()->setCellValue('C2','CONCEPTO');
					$this->docexcel->getActiveSheet()->setCellValue('D2','TIPO');
					$this->docexcel->getActiveSheet()->setCellValue('E2','NRO DOCUMENTO');		
					$this->docexcel->getActiveSheet()->setCellValue('F2','NRO TRAMITE');								
					$this->docexcel->getActiveSheet()->setCellValue('G2','IMPORTE TOTAL');
					
					$this->docexcel->getActiveSheet()->setCellValue('H3','IT');				
					$this->docexcel->getActiveSheet()->setCellValue('I3','IUE');
					$this->docexcel->getActiveSheet()->setCellValue('J3','IT');
					$this->docexcel->getActiveSheet()->setCellValue('K3','IUE');														
					$this->docexcel->getActiveSheet()->setCellValue('L3','IT');				
					$this->docexcel->getActiveSheet()->setCellValue('M3','RC-IVA');
					
					$this->docexcel->getActiveSheet()->setCellValue('N2','IMPUESTOS DESCUENTO DE LEY');
					$this->docexcel->getActiveSheet()->setCellValue('O2','DESCUENTOS');
					$this->docexcel->getActiveSheet()->setCellValue('P2','LIQUIDO');
					break;
				case 'rcrb':
					$this->docexcel->getActiveSheet()->getStyle('E1:G1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'RETENCION BIENES');						
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getStyle('A3:L3')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(80);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(18);			
					//*************************************Cabecera************************//
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->getAlignment()->setWrapText(true);
					$this->docexcel->getActiveSheet()->getStyle('A3:L3')->getAlignment()->setWrapText(true);
					 
					$this->docexcel->getActiveSheet()->mergeCells('A2:A3');
					$this->docexcel->getActiveSheet()->mergeCells('B2:B3');
					$this->docexcel->getActiveSheet()->mergeCells('C2:C3');
					$this->docexcel->getActiveSheet()->mergeCells('D2:D3');
					$this->docexcel->getActiveSheet()->mergeCells('E2:E3');
					$this->docexcel->getActiveSheet()->mergeCells('F2:F3');
					$this->docexcel->getActiveSheet()->mergeCells('G2:G3');
					$this->docexcel->getActiveSheet()->mergeCells('J2:J3');
					$this->docexcel->getActiveSheet()->mergeCells('K2:K3');
					$this->docexcel->getActiveSheet()->mergeCells('L2:L3');
									
					$this->docexcel->getActiveSheet()->mergeCells('H2:I2');
	
					$this->docexcel->getActiveSheet()->setCellValue('H2','BIENES');
						
					$this->docexcel->getActiveSheet()->setCellValue('A2','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B2','FECHA DE LA FACTURA O DUI');
					$this->docexcel->getActiveSheet()->setCellValue('C2','CONCEPTO');
					$this->docexcel->getActiveSheet()->setCellValue('D2','TIPO');		
					$this->docexcel->getActiveSheet()->setCellValue('E2','NRO DOCUMENTO');				
					$this->docexcel->getActiveSheet()->setCellValue('F2','NRO TRAMITE');			
					$this->docexcel->getActiveSheet()->setCellValue('G2','IMPORTE TOTAL');	
								
					$this->docexcel->getActiveSheet()->setCellValue('H3','IT');				
					$this->docexcel->getActiveSheet()->setCellValue('I3','IUE');
					
					$this->docexcel->getActiveSheet()->setCellValue('J2','IMPUESTOS DESCUENTO DE LEY');
					$this->docexcel->getActiveSheet()->setCellValue('K2','DESCUENTOS');
					$this->docexcel->getActiveSheet()->setCellValue('L2','LIQUIDO');			
					break;
				case 'rcrs':
					$this->docexcel->getActiveSheet()->getStyle('E1:G1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'RETENCION SERVICIOS');						
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getStyle('A3:L3')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(80);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);			
					//*************************************Cabecera************************//
					$this->docexcel->getActiveSheet()->getStyle('A2:K2')->getAlignment()->setWrapText(true);
					$this->docexcel->getActiveSheet()->getStyle('A3:K3')->getAlignment()->setWrapText(true);
					 
					$this->docexcel->getActiveSheet()->mergeCells('A2:A3');
					$this->docexcel->getActiveSheet()->mergeCells('B2:B3');
					$this->docexcel->getActiveSheet()->mergeCells('C2:C3');
					$this->docexcel->getActiveSheet()->mergeCells('D2:D3');
					$this->docexcel->getActiveSheet()->mergeCells('E2:E3');
					$this->docexcel->getActiveSheet()->mergeCells('F2:F3');
					$this->docexcel->getActiveSheet()->mergeCells('G2:G3');
					$this->docexcel->getActiveSheet()->mergeCells('J2:J3');
					$this->docexcel->getActiveSheet()->mergeCells('K2:K3');
					$this->docexcel->getActiveSheet()->mergeCells('L2:L3');
									
					$this->docexcel->getActiveSheet()->mergeCells('H2:I2');
	
					$this->docexcel->getActiveSheet()->setCellValue('H2','SERVICIOS');
						
					$this->docexcel->getActiveSheet()->setCellValue('A2','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B2','FECHA DE LA FACTURA O DUI');
					$this->docexcel->getActiveSheet()->setCellValue('C2','CONCEPTO');
					$this->docexcel->getActiveSheet()->setCellValue('D2','TIPO');		
					$this->docexcel->getActiveSheet()->setCellValue('E2','NRO DOCUMENTO');				
					$this->docexcel->getActiveSheet()->setCellValue('F2','NRO TRAMITE');			
					$this->docexcel->getActiveSheet()->setCellValue('G2','IMPORTE TOTAL');	
					
					$this->docexcel->getActiveSheet()->setCellValue('H3','IT');				
					$this->docexcel->getActiveSheet()->setCellValue('I3','IUE');
					
					$this->docexcel->getActiveSheet()->setCellValue('J2','IMPUESTOS DESCUENTO DE LEY');
					$this->docexcel->getActiveSheet()->setCellValue('K2','DESCUENTOS');
					$this->docexcel->getActiveSheet()->setCellValue('L2','LIQUIDO');				
					break;
				case 'rcra':
					$this->docexcel->getActiveSheet()->getStyle('E1:G1')->applyFromArray($styleTitulos3);	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'RETENCION ALQUILERES');						
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getStyle('A3:L3')->applyFromArray($styleTitulos2);
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(80);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(18);			
					//*************************************Cabecera************************//
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->getAlignment()->setWrapText(true);
					$this->docexcel->getActiveSheet()->getStyle('A3:L3')->getAlignment()->setWrapText(true);
					 
					$this->docexcel->getActiveSheet()->mergeCells('A2:A3');
					$this->docexcel->getActiveSheet()->mergeCells('B2:B3');
					$this->docexcel->getActiveSheet()->mergeCells('C2:C3');
					$this->docexcel->getActiveSheet()->mergeCells('D2:D3');
					$this->docexcel->getActiveSheet()->mergeCells('E2:E3');
					$this->docexcel->getActiveSheet()->mergeCells('F2:F3');
					$this->docexcel->getActiveSheet()->mergeCells('G2:G3');
					$this->docexcel->getActiveSheet()->mergeCells('J2:J3');
					$this->docexcel->getActiveSheet()->mergeCells('K2:K3');
					$this->docexcel->getActiveSheet()->mergeCells('L2:L3');
									
					$this->docexcel->getActiveSheet()->mergeCells('H2:I2');
	
					$this->docexcel->getActiveSheet()->setCellValue('H2','ALQUILERES');
						
					$this->docexcel->getActiveSheet()->setCellValue('A2','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B2','FECHA DE LA FACTURA O DUI');
					$this->docexcel->getActiveSheet()->setCellValue('C2','CONCEPTO');
					$this->docexcel->getActiveSheet()->setCellValue('D2','TIPO');		
					$this->docexcel->getActiveSheet()->setCellValue('E2','NRO DOCUMENTO');				
					$this->docexcel->getActiveSheet()->setCellValue('F2','NRO TRAMITE');			
					$this->docexcel->getActiveSheet()->setCellValue('G2','IMPORTE TOTAL');	
								
					$this->docexcel->getActiveSheet()->setCellValue('H3','IT');				
					$this->docexcel->getActiveSheet()->setCellValue('I3','RCV-IVA');
					
					$this->docexcel->getActiveSheet()->setCellValue('J2','IMPUESTOS DESCUENTO DE LEY');
					$this->docexcel->getActiveSheet()->setCellValue('K2','DESCUENTOS');
					$this->docexcel->getActiveSheet()->setCellValue('L2','LIQUIDO');							
					break;
				default:			
					break;
			}
		}		
	}

	function generarDatos()
	{
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$this->numero = 1;
		$fila = 4;
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(0,'RESULTADOS');
		$tipo =$this->objParam->getParametro('tipo_ret');
							
		switch ($tipo) {
			case 'todo':
				foreach ($datos as $value){										
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['fecha']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, trim($value['obs']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['plantilla']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['nro_documento']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nro_tramite']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_doc']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['it_bienes']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['iue_bienes']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['it_servicios']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['iue_servicios']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['it_alquileres']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['rc_iva_alquileres']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['importe_descuento_ley']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['descuento']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $value['liquido']);
					
					$fila++;
					$this->numero++;		
				}
				//
				$this->docexcel->getActiveSheet()->getStyle('G'.(4).':G'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('H'.(4).':H'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('I'.(4).':I'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('J'.(4).':J'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('K'.(4).':K'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('L'.(4).':L'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('M'.(4).':M'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('N'.(4).':N'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('O'.(4).':O'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				//
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':P'.($fila+1).'')->applyFromArray($styleTitulos3);				
				//
				$this->docexcel->getActiveSheet()->getStyle('G'.($fila+1).':P'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				//			
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'TOTAL');
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G4:G'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H4:H'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I4:I'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J4:J'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K4:K'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L4:L'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila+1,'=SUM(M4:M'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila+1,'=SUM(N4:N'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila+1,'=SUM(O4:O'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila+1,'=SUM(P4:P'.($fila-1).')');
												
				$formula = '=SUM(G1:G'.($fila-1).')';
				$sum = PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula, 'A1', $this->docexcel->getActiveSheet()->getCell('A1'));
							
				break;
				
			case 'rcrb':
				foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['fecha']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, trim($value['obs']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['plantilla']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['nro_documento']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, trim($value['nro_tramite']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_doc']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['it_bienes']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['iue_bienes']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_descuento_ley']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['descuento']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['liquido']);
					$fila++;
					$this->numero++;		
				}
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':L'.($fila+1).'')->applyFromArray($styleTitulos3);				
								
				$this->docexcel->getActiveSheet()->getStyle('G'.(4).':G'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('H'.(4).':H'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('I'.(4).':I'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('J'.(4).':J'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('K'.(4).':K'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('L'.(4).':L'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');	
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'TOTAL');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G4:G'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H4:H'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I4:I'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J4:J'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K4:K'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L4:L'.($fila-1).')');				
				break;
			case 'rcrs':
				foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['fecha']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, trim($value['obs']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['plantilla']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['nro_documento']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nro_tramite']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_doc']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['it_servicios']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['iue_servicios']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_descuento_ley']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['descuento']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['liquido']);
					$fila++;
					$this->numero++;		
				}
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':L'.($fila+1).'')->applyFromArray($styleTitulos3);			
				$this->docexcel->getActiveSheet()->getStyle('G'.(4).':G'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('H'.(4).':H'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('I'.(4).':I'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('J'.(4).':J'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('K'.(4).':K'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('L'.(4).':L'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'TOTAL');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G4:G'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H4:H'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I4:I'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J4:J'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K4:K'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L4:L'.($fila-1).')');						
				break;
			case 'rcra':
				foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['fecha']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, trim($value['obs']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['plantilla']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['nro_documento']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nro_tramite']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_doc']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['it_alquileres']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['rc_iva_alquileres']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_descuento_ley']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['descuento']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['liquido']);
					$fila++;
					$this->numero++;		
				}				
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':L'.($fila+1).'')->applyFromArray($styleTitulos3);			
				$this->docexcel->getActiveSheet()->getStyle('G'.(4).':G'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('H'.(4).':H'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('I'.(4).':I'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('J'.(4).':J'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('K'.(4).':K'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('L'.(4).':L'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');	
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'TOTAL');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G4:G'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H4:H'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I4:I'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J4:J'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K4:K'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L4:L'.($fila-1).')');			
				break;
			default:			
				break;
					
		}	
		$this->generarResultado(1,$sum);
	}
	//
	function generarReporte(){
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);
	}
	
	function generarResultado ($sheet,$a){
		$this->docexcel->createSheet($sheet);
		$this->docexcel->setActiveSheetIndex(0);
		$this->imprimeCabecera($sheet,'TOTAL');
		$this->docexcel->getActiveSheet()->setTitle('TOTALES');
		$this->docexcel->getActiveSheet()->setCellValue('E5','TOTAL');
		$this->docexcel->getActiveSheet()->setCellValue('F5',$a);
		
	}
	
}
?>
