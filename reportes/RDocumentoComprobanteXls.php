<?php
class RDocumentoComprobanteXls
{
    private $fila;
    private $objParam;

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

    function datosHeader ( $detalle) {

        $this->datos_detalle = $detalle;


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

        $this->docexcel->getActiveSheet()->getStyle('A1:W1')->applyFromArray($styleTitulos);

        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[0])->setWidth(10);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,1,'Fecha');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[1])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,1,'Nit');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[2])->setWidth(30);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,1,'Razon Social');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[3])->setWidth(25);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,1,'Tipo Documento');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,1,'Nro Documento');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(20);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,1,'Nro DUI');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[6])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,1,'Nro Autorizacion');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[7])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,1,'Codigo Control');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[8])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,1,'Importe');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[9])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,1,'ICE');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[10])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,1,'Descuento');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[11])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,1,'Exento');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[12])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(12,1,'Pago Liquido');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[13])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(13,1,'Importe Sujeto');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[14])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(14,1,'Importe Iva');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[15])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(15,1,'Importe Gasto');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[16])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(16,1,'% Prorrateo Gasto');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[17])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(17,1,'Sujeto Prorrateo');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[18])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(18,1,'Iva Prorrateo');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[19])->setWidth(10);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(19,1,'Codigo');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[20])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(20,1,'Cuenta');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[21])->setWidth(20);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(21,1,'Origen');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[22])->setWidth(15);
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(22,1,'Comprobante');
        //*************************************Fin Cabecera*****************************************

        $fila = 2;
        $contador = 1;

        /////////////////////***********************************Detalle***********************************************
        foreach($datos as $value) {

            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$value['fecha']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['nit']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['razon_social']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$value['desc_plantilla']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$value['nro_documento']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['nro_dui']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$value['nro_autorizacion']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,$value['codigo_control']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,$fila,$value['importe_doc']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,$fila,$value['importe_ice']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,$fila,$value['importe_descuento']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,$fila,$value['importe_excento']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(12,$fila,$value['liquido']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(13,$fila,$value['importe_sujeto']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(14,$fila,$value['importe_iva']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(15,$fila,$value['importe_gasto']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(16,$fila,$value['porc_gasto_prorrateado']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(17,$fila,$value['sujeto_prorrateado']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(18,$fila,$value['iva_prorrateado']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(19,$fila,$value['codigo']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(20,$fila,$value['nro_cuenta']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(21,$fila,$value['origen']);
            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(22,$fila,$value['id_int_comprobante']);

            $fila++;
            $contador++;
        }
        //************************************************Fin Detalle***********************************************

    }

    function generarReporte(){

        $this->imprimeDatos();

        //echo $this->nombre_archivo; exit;
        // Set active sheet index to the first sheet, so Excel opens this as the first sheet
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }


}

?>