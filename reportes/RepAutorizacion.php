<?php
/**   
 *   HISTORIAL DE MODIFICACIONES:	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
 #112			  17/04/2020		manu				 reportes de autorizacion de pasajes y registro de pasajeros
 **/
class RepAutorizacion
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;
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
		$this->printerConfiguration();
	}
	function datosHeader ($detalle) {
		$this->datos_detalle = $detalle;
	}		
	//
	function generarReporte(){
		//pendientes
		$this->docexcel->setActiveSheetIndex(0);
		//$this->imprimeTitulo($sheet,0);
		$this->imprimeCabecera();
		$this->generarDatos();
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);
	}
	//
	function printerConfiguration(){
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_LETTER);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToWidth(1);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToHeight(0);
	}
	
	function imprimeTitulo($sheet,$i) {
		//Logo
		$objDrawing = new PHPExcel_Worksheet_Drawing();
		$objDrawing->setName('Logo');
		$objDrawing->setDescription('Logo');
		$objDrawing->setPath(dirname(__FILE__).'/../../lib/imagenes/logos');
		$objDrawing->setHeight(50);
		$objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex($i));
	}
	//
	function imprimeCabecera() {
		$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Entregados');	
		$this->docexcel->setActiveSheetIndex(0);		
		$styleTitulos1 = array(
			'font'  => array(
				'bold'  => false,
				'size'  => 15
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$styleTitulos2 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 8,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '0066CC'
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
				'size'  => 11,
				'name'  => 'Arial'
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		
		$this->docexcel->getActiveSheet()->getStyle('D3:J3')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->mergeCells('D3:J3');
		$this->docexcel->getActiveSheet()->setCellValue('D3','DETALLE DE PASAJES PARA AUTORIZACION');
		$this->docexcel->getActiveSheet()->getStyle('B5:M5')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('B5:M5')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('B5','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('C5','NOTA DE DEBITO');
		$this->docexcel->getActiveSheet()->setCellValue('D5','NOMBRE DEL PASAJERO');
		$this->docexcel->getActiveSheet()->setCellValue('E5','Nº FACTURA');
		$this->docexcel->getActiveSheet()->setCellValue('F5','PROCESO(VI/FA)');
		$this->docexcel->getActiveSheet()->setCellValue('G5','MOTIVO, FECHA Y RUTA');
		$this->docexcel->getActiveSheet()->setCellValue('H5','CENTRO DE COSTO');
		$this->docexcel->getActiveSheet()->setCellValue('I5','MONEDA');
		$this->docexcel->getActiveSheet()->setCellValue('J5','IMPORTE');
		$this->docexcel->getActiveSheet()->setCellValue('K5','PASAJE UTLIZADO');
		$this->docexcel->getActiveSheet()->setCellValue('L5','FIRMA AUTORIZADA');
		$this->docexcel->getActiveSheet()->setCellValue('M5','NOMBRE');
			
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(7);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);	
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);	
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(8);	
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(8);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(12);
	}
	//
	function generarDatos()
	{	
		$styleTitulos2 = array(
			'font'  => array(
				'bold'  => FALSE,
				'size'  => 8,
				'name'  => 'Arial'
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
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
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
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
		$styleTitulos = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '0066CC'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$this->numero = 1;
		$fila = 6;
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(0);
		foreach ($datos as $value){	
			$this->docexcel->getActiveSheet()->getStyle('B'.$fila.':J'.$fila.'')->applyFromArray($styleTitulos2);
			$this->docexcel->getActiveSheet()->getStyle('G'.$fila.':G'.$fila.'')->getAlignment()->setWrapText(true);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $this->numero);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, trim($value['nota_debito_agencia']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['desc_funcionario2']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['nro_documento']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, trim($value['nro_tramite']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, trim($value['obs']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, trim($value['descripcion']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, trim($value['desc_moneda']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_doc']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['consumido']);
			$fila++;
			$this->numero++;
		}
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila+1).':C'.($fila+1).'')->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->getStyle('D'.(6).':D'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
			
		$this->docexcel->getActiveSheet()->getStyle('D'.($fila+1).':J'.($fila+1).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->mergeCells('B'.($fila+1).':C'.($fila+1).'');  
		$this->docexcel->getActiveSheet()->setCellValue('B'.($fila+1).'','TOTAL');

		$this->docexcel->getActiveSheet()->mergeCells('D'.($fila+1).':J'.($fila+1).'');  
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila+1,'=SUM(J6:J'.($fila-1).')');	
		
		$this->docexcel->getActiveSheet()->getStyle('D'.($fila+4).':E'.($fila+4).'')->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->getStyle('G'.($fila+4).':G'.($fila+4).'')->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->mergeCells('D'.($fila+4).':E'.($fila+4).''); 	
		$this->docexcel->getActiveSheet()->setCellValue('D'.($fila+4).'','DPTO DE CONTABILIDAD');
		$this->docexcel->getActiveSheet()->setCellValue('G'.($fila+4).'','DPTO DE FINANZAS');

	}
}
?>