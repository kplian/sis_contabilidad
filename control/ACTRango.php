<?php
/**
*@package pXP
*@file gen-ACTRango.php
*@author  (admin)
*@date 22-06-2017 21:30:05
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRango extends ACTbase{    
			
	function listarRango(){
		$this->objParam->defecto('ordenacion','id_gestion desc, id_periodo');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_tipo_cc')!=''){
            $this->objParam->addFiltro("ran.id_tipo_cc = ''".$this->objParam->getParametro('id_tipo_cc')."''");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRango','listarRango');
		} else{
			$this->objFunc=$this->create('MODRango');
			
			$this->res=$this->objFunc->listarRango($this->objParam);
		}
		
	    $temp = Array();
		$temp['debe_mb'] = $this->res->extraData['debe_mb'];
		$temp['haber_mb'] = $this->res->extraData['haber_mb'];
		$temp['debe_mt'] = $this->res->extraData['debe_mt'];
		$temp['haber_mt'] = $this->res->extraData['haber_mt'];
		$temp['memoria'] = $this->res->extraData['memoria'];
		$temp['formulado'] = $this->res->extraData['formulado'];
		$temp['comprometido'] = $this->res->extraData['comprometido'];
		$temp['ejecutado'] = $this->res->extraData['ejecutado'];
		$temp['balance_mb'] = $this->res->extraData['balance_mb'];	
		
				
							
				
		$temp['tipo_reg'] = 'summary';
		$temp['id_rango'] = 0;
		
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRango(){
		$this->objFunc=$this->create('MODRango');	
		if($this->objParam->insertar('id_rango')){
			$this->res=$this->objFunc->insertarRango($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRango($this->objParam);
		}
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRango(){
		$this->objFunc=$this->create('MODRango');	
		$this->res=$this->objFunc->eliminarRango($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   
    	
    function listarTipoCcArbRep(){
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_tipo_cc');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_tipo_cc);
        }
        
		$this->objFunc=$this->create('sis_contabilidad/MODRango');
        $this->res=$this->objFunc->listarTipoCcArbRep();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_tipo_cc'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_tipo_cc_fk'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #codigo# - #balance_mb#</b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'nombre_cuenta'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><br/><br> #descripcion#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
														
		
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

   }

   function sincronizarRangos(){
     	$this->objFunc=$this->create('MODRango');	
		$this->res=$this->objFunc->sincronizarRangos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	
   }
			
}

?>