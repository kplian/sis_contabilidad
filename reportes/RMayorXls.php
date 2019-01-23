<?php
/*
 ISSUE      FORK         FECHA:		         AUTOR                              DESCRIPCION
 #24       ENDEETR  	18/01/2019        manuel guerra            agrega las columnas dolares y Ufvs, incluyendo totales
 #25       ENDEETR  	18/01/2019        manuel guerra            agrega la columna id_cbte, al reporte excel
*/


class RMayorXls
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
		set_time_limit(800);
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
	//
	function imprimeCabecera() {
		$this->docexcel->createSheet();
		$this->docexcel->getActiveSheet()->setTitle('Libro Mayor');
		$this->docexcel->setActiveSheetIndex(0);
		
		$datos = $this->objParam->getParametro('datos');
		$var = array();
		$contador=0;
		$styleTitulos1 = array(
			'font'  => array(
			    'bold'  => true,
			    'size'  => 12,
			    'name'  => 'Arial'
			),
			'alignment' => array(
			    'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			    'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);

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
		//		
		$cc= (int)($this->objParam->getParametro('cc') === 'true');		
		$partida = (int)($this->objParam->getParametro('partida')=== 'true');
		$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
		$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
		$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
		$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
		$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
		$fec = (int)($this->objParam->getParametro('fec')=== 'true');	
		$cuenta = (int)($this->objParam->getParametro('cuenta_t')=== 'true');						

		$aux='';		
		if($cc == 1){
			array_push($var,'CENTRO COSTO');
			$contador++;						
		}
		if($partida == 1){
			array_push($var,'PARTIDA');
			$contador++;						
		}
		if($auxiliar == 1){
			array_push($var,'AUXILIAR');
			$contador++;						
		}
		if($ordenes == 1){
			array_push($var,'ORDENES');
			$contador++;
		}
		if($tramite == 1){
			array_push($var,'TRAMITE');
			$contador++;
		}
		if($crel == 1 ){
			array_push($var,'RELACIONAL');
			$contador++;
		}		
		if($nro_comprobante == 1){
			array_push($var,'NRO COMPROBANTE');
			$contador++;
		}	
		if($fec == 1){
			array_push($var,'FECHA');						
			$contador++;
		}	
		if($cuenta == 1){
			array_push($var,'CUENTA CONTABLE');						
			$contador++;
		}
		$this->docexcel->getActiveSheet()->setCellValue('A5','No.');
		//titulos
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'LIBRO DE MAYOR' );
		$this->docexcel->getActiveSheet()->getStyle('A2:'.$this->equivalencias[$contador].'2')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('A2:'.$this->equivalencias[$contador].'2');
				
		$this->docexcel->getActiveSheet()->getStyle('A5:'.$this->equivalencias[$contador+5].'5')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('A5:'.$this->equivalencias[$contador+5].'5')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************	
		for ($i=1; $i <= $contador; $i++) {
			$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$i].'5',$var[$i-1]);
			$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$i].'')->setWidth(35); 			
		}
		$contador+=3;
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador-1].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+1].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+2].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+3].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+4].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+5].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+6].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+7].'')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$contador+8].'')->setWidth(15);
		
		$this->docexcel->getActiveSheet()->getColumnDimension(''.$this->equivalencias[$i].'')->setWidth(40);
		$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador-2].'5','CBTE');
		$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador-1].'5','GLOSA');
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':				
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador].'5','DEBE'.' '.'MA');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+1].'5','HABER'.' '.'MA');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+2].'5','SALDO'.' '.'MA');				
				break;
			case 'MT':			
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador].'5','DEBE'.' '.'MT');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+1].'5','HABER'.' '.'MT');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+2].'5','SALDO'.' '.'MT');				
				break;
			case 'MB':
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador].'5','DEBE'.' '.'MB');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+1].'5','HABER'.' '.'MB');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+2].'5','SALDO'.' '.'MB');			
				break;
			#24		
			case 'TM':					
				$this->docexcel->getActiveSheet()->getStyle('A5:'.$this->equivalencias[$contador+8].'5')->getAlignment()->setWrapText(true);
				$this->docexcel->getActiveSheet()->getStyle('A5:'.$this->equivalencias[$contador+8].'5')->applyFromArray($styleTitulos2);	
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador].'5','DEBE'.' '.'MB');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+1].'5','HABER'.' '.'MB');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+2].'5','SALDO'.' '.'MB');	
				
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+3].'5','DEBE'.' '.'MT');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+4].'5','HABER'.' '.'MT');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+5].'5','SALDO'.' '.'MT');
				
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+6].'5','DEBE'.' '.'MA');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+7].'5','HABER'.' '.'MA');
				$this->docexcel->getActiveSheet()->setCellValue(''.$this->equivalencias[$contador+8].'5','SALDO'.' '.'MA');
				$contador+=9;							
				break;			
			default:			
				break;
		}
	}
	//
	function generarDatos()
	{
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
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_TOP,
			),
		);
		$this->numero = 1;
		$fila = 6;
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(0);
		$contador=0;
		$k=1;
		$t=0;
		$acreedor=0;
		$ar = array();
		
		//
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				foreach ($datos as $value){					
					$cc= (int)($this->objParam->getParametro('cc') === 'true');		
					$partida = (int)($this->objParam->getParametro('partida')=== 'true');
					$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
					$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
					$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
					$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
					$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
					$fec = (int)($this->objParam->getParametro('fec')=== 'true');
					$cuenta = (int)($this->objParam->getParametro('cuenta_t')=== 'true');						
					
					$aux='';		
					if($cc == 1){
						array_push($ar,trim($value['desc_centro_costo']));$contador++;						
					}
					if($partida == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;						
					}
					if($auxiliar == 1){
						array_push($ar,trim($value['desc_auxiliar']));$contador++;						
					}
					if($ordenes == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;
					}
					if($tramite == 1){
						array_push($ar,strval($value['nro_tramite']));$contador++;
					}
					if($crel == 1 ){
						array_push($ar,$value['cbte_relacional']);$contador++;
					}		
					if($nro_comprobante == 1){
						array_push($ar,trim($value['nro_cbte']));$contador++;
					}	
					if($fec == 1){						
						$arr = explode('-', $value['fecha']);
						$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
						$aux=$aux.$newDate."\r\n";
						array_push($ar,$newDate);$contador++;
					}
					if($cuenta == 1){
						array_push($ar,trim($value['desc_cuenta']));$contador++;
					}
					
					if($k==1){
						$max=$contador;
					}
					$k=2;
					$v=0;				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					for ($i=$t; $i < $max+$t ; $i++) { 						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($v+1, $fila, $ar[$i]);
						$v++;				
					}	
					$t=$t+$max;					
					$acreedor = ($value['importe_debe_ma']-$value['importe_haber_ma']) + $acreedor;		
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+1, $fila, trim($value['glosa1'])."\r\n".trim($value['glosa']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+2, $fila, $value['id_int_comprobante']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+3, $fila, $value['importe_debe_ma']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+4, $fila, $value['importe_haber_ma']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+5, $fila, $acreedor);
					$fila++;
					$this->numero++;
				}	
	
				break;
			case 'MT':			
				foreach ($datos as $value){					
					$cc= (int)($this->objParam->getParametro('cc') === 'true');		
					$partida = (int)($this->objParam->getParametro('partida')=== 'true');
					$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
					$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
					$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
					$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
					$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
					$fec = (int)($this->objParam->getParametro('fec')=== 'true');
					$fec = (int)($this->objParam->getParametro('cuenta_t')=== 'true');							
					
					$aux='';		
					if($cc == 1){
						array_push($ar,trim($value['desc_centro_costo']));$contador++;						
					}
					if($partida == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;						
					}
					if($auxiliar == 1){
						array_push($ar,trim($value['desc_auxiliar']));$contador++;						
					}
					if($ordenes == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;
					}
					if($tramite == 1){
						array_push($ar,strval($value['nro_tramite']));$contador++;
					}
					if($crel == 1 ){
						array_push($ar,$value['cbte_relacional']);$contador++;
					}		
					if($nro_comprobante == 1){
						array_push($ar,trim($value['nro_cbte']));$contador++;
					}	
					if($fec == 1){						
						$arr = explode('-', $value['fecha']);
						$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
						$aux=$aux.$newDate."\r\n";
						array_push($ar,$newDate);$contador++;
					}
					if($cuenta == 1){
						array_push($ar,trim($value['desc_cuenta']));$contador++;
					}
					if($k==1){
						$max=$contador;
					}
					$k=2;
					$v=0;
					//$this->docexcel->getActiveSheet()->getRowDimension($fila)->setRowHeight(60);					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					for ($i=$t; $i < $max+$t ; $i++) { 						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($v+1, $fila, $ar[$i]);
						$v++;				
					}	
					$t=$t+$max;					
					$acreedor = ($value['importe_debe_mt']-$value['importe_haber_mt']) + $acreedor;		
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+1, $fila, trim($value['glosa1'])."\r\n".trim($value['glosa']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+2, $fila, $value['id_int_comprobante']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+3, $fila, $value['importe_debe_mt']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+4, $fila, $value['importe_haber_mt']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+5, $fila, $acreedor);
					$fila++;
					$this->numero++;
				}	
				break;
			case 'MB':
				//var_dump($datos);
				foreach ($datos as $value){					
					$cc= (int)($this->objParam->getParametro('cc') === 'true');		
					$partida = (int)($this->objParam->getParametro('partida')=== 'true');
					$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
					$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
					$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
					$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
					$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
					$fec = (int)($this->objParam->getParametro('fec')=== 'true');
					$cuenta = (int)($this->objParam->getParametro('cuenta_t')=== 'true');						
					
					$aux='';		
					if($cc == 1){
						array_push($ar,trim($value['desc_centro_costo']));$contador++;						
					}
					if($partida == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;						
					}
					if($auxiliar == 1){
						array_push($ar,trim($value['desc_auxiliar']));$contador++;						
					}
					if($ordenes == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;
					}
					if($tramite == 1){
						array_push($ar,strval($value['nro_tramite']));$contador++;
					}
					if($crel == 1 ){
						array_push($ar,$value['cbte_relacional']);$contador++;
					}		
					if($nro_comprobante == 1){
						array_push($ar,trim($value['nro_cbte']));$contador++;
					}	
					if($fec == 1){						
						$arr = explode('-', $value['fecha']);
						$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
						$aux=$aux.$newDate."\r\n";
						array_push($ar,$newDate);$contador++;
					}
					if($cuenta == 1){
						array_push($ar,trim($value['desc_cuenta']));$contador++;
					}
					if($k==1){
						$max=$contador;
					}
					$k=2;
					$v=0;				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					for ($i=$t; $i < $max+$t ; $i++) { 						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($v+1, $fila, $ar[$i]);
						$v++;				
					}	
					$t=$t+$max;					
					
					$acreedor = ($value['importe_debe_mb']-$value['importe_haber_mb']) + $acreedor;		
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+1, $fila, $value['id_int_comprobante']);							
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+2, $fila, trim($value['glosa1'])."\r\n".trim($value['glosa']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+3, $fila, $value['importe_debe_mb']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+4, $fila, $value['importe_haber_mb']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+5, $fila, $acreedor);
					$fila++;
					$this->numero++;
				}			
				break;	
			#24	
			case 'TM':
				foreach ($datos as $value){					
					$cc= (int)($this->objParam->getParametro('cc') === 'true');		
					$partida = (int)($this->objParam->getParametro('partida')=== 'true');
					$auxiliar = (int)($this->objParam->getParametro('auxiliar')=== 'true');
					$ordenes = (int)($this->objParam->getParametro('ordenes')=== 'true');
					$tramite = (int)($this->objParam->getParametro('tramite')=== 'true');
					$crel = (int)($this->objParam->getParametro('relacional')=== 'true');			
					$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
					$fec = (int)($this->objParam->getParametro('fec')=== 'true');
					$cuenta = (int)($this->objParam->getParametro('cuenta_t')=== 'true');						
					
					$aux='';		
					if($cc == 1){
						array_push($ar,trim($value['desc_centro_costo']));$contador++;						
					}
					if($partida == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;						
					}
					if($auxiliar == 1){
						array_push($ar,trim($value['desc_auxiliar']));$contador++;						
					}
					if($ordenes == 1){
						array_push($ar,trim($value['desc_partida']));$contador++;
					}
					if($tramite == 1){
						array_push($ar,strval($value['nro_tramite']));$contador++;
					}
					if($crel == 1 ){
						array_push($ar,$value['cbte_relacional']);$contador++;
					}		
					if($nro_comprobante == 1){
						array_push($ar,trim($value['nro_cbte']));$contador++;
					}	
					if($fec == 1){						
						$arr = explode('-', $value['fecha']);
						$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
						$aux=$aux.$newDate."\r\n";
						array_push($ar,$newDate);$contador++;
					}
					if($cuenta == 1){
						array_push($ar,trim($value['desc_cuenta']));$contador++;
					}
					if($k==1){
						$max=$contador;
					}
					$k=2;
					$v=0;				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
					for ($i=$t; $i < $max+$t ; $i++) { 						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($v+1, $fila, $ar[$i]);
						$v++;				
					}	
					$t=$t+$max;					
					
					$acreedor = ($value['importe_debe_mb']-$value['importe_haber_mb']) + $acreedor;		
					#25											
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+1, $fila, $value['id_int_comprobante']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+2, $fila, trim($value['glosa1'])."\r\n".trim($value['glosa']));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+3, $fila, $value['importe_debe_mb']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+4, $fila, $value['importe_haber_mb']);					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+5, $fila, $acreedor);										
														
					$acreedort = ($value['importe_debe_mt']-$value['importe_haber_mt']) + $acreedort;	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+6, $fila, $value['importe_debe_mt']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+7, $fila, $value['importe_haber_mt']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+8, $fila, $acreedort);
					
					$acreedora = ($value['importe_debe_ma']-$value['importe_haber_ma']) + $acreedora;	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+9, $fila, $value['importe_debe_ma']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+10, $fila, $value['importe_haber_ma']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+11, $fila, $acreedora);
										
					$fila++;
					$this->numero++;
				}
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':'.$this->equivalencias[$max+11].($fila+1).'')->applyFromArray($styleTitulos2);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+2, $fila+1,'TOTAL');
				//bs
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+3].'6:'.$this->equivalencias[$max+3].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+3,$fila+1,'=SUM('.$this->equivalencias[$max+3].'6:'.$this->equivalencias[$max+3].($fila-1).')');
																
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+4].'6:'.$this->equivalencias[$max+4].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+4,$fila+1,'=SUM('.$this->equivalencias[$max+4].'6:'.$this->equivalencias[$max+4].($fila-1).')');
				
				$deb = 'SUM('.$this->equivalencias[$max+3].'6:'.$this->equivalencias[$max+3].($fila-1).')';					
				$hab = 'SUM('.$this->equivalencias[$max+4].'6:'.$this->equivalencias[$max+4].($fila-1).')';	
				$vari = '=+'.$deb.'-'.$hab;
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+5].'6:'.$this->equivalencias[$max+5].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+5,$fila+1,$vari);
				//dolares
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+6].'6:'.$this->equivalencias[$max+6].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+6,$fila+1,'=SUM('.$this->equivalencias[$max+6].'6:'.$this->equivalencias[$max+6].($fila-1).')');
								
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+7].'6:'.$this->equivalencias[$max+7].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+7,$fila+1,'=SUM('.$this->equivalencias[$max+7].'6:'.$this->equivalencias[$max+7].($fila-1).')');
				
				$deb = 'SUM('.$this->equivalencias[$max+6].'6:'.$this->equivalencias[$max+6].($fila-1).')';					
				$hab = 'SUM('.$this->equivalencias[$max+7].'6:'.$this->equivalencias[$max+7].($fila-1).')';	
				$vari = '=+'.$deb.'-'.$hab;
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+8].'6:'.$this->equivalencias[$max+8].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+8,$fila+1,$vari);
				//ufv
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+9].'6:'.$this->equivalencias[$max+9].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+9,$fila+1,'=SUM('.$this->equivalencias[$max+9].'6:'.$this->equivalencias[$max+9].($fila-1).')');
								
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+10].'6:'.$this->equivalencias[$max+10].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+10,$fila+1,'=SUM('.$this->equivalencias[$max+10].'6:'.$this->equivalencias[$max+10].($fila-1).')');
				
				$deb = 'SUM('.$this->equivalencias[$max+9].'6:'.$this->equivalencias[$max+9].($fila-1).')';					
				$hab = 'SUM('.$this->equivalencias[$max+10].'6:'.$this->equivalencias[$max+10].($fila-1).')';	
				$vari = '=+'.$deb.'-'.$hab;
				$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$max+11].'6:'.$this->equivalencias[$max+11].($fila+1))->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max+11,$fila+1,$vari);
				break;	
			default:			
				break;
		}					
	}
	function generarReporte(){
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel2007');
		$this->objWriter->save($this->url_archivo);
		$this->imprimeCabecera(0);
	}	

}
?>