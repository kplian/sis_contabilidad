<font size="7"><table width="100%" cellpadding="1px"  rules="cols" border="0">

<tr>

		    <td width="<?php  echo $with_col; ?>" style="border-left: 1px solid #000; vertical-align: bottom ;"><div><br>
				<b>CC:</b> <?php  echo  $val['cc']; ?> 
			<?php if  ($val['codigo_partida']!=''){ 
				
				   if ($val['sw_movimiento']=='presupuestaria'){  ?>	
	   			      <br/><font color="green"><b>Ptda.:</b> <?php  echo $val['codigo_partida'].'-'.$val['nombre_partida']; ?></font>
	   		<?php }
				   else {?>
				   	  <br/><font color="red"><b>Ptda.:</b> <?php  echo $val['codigo_partida'].'-'.$val['nombre_partida']; ?></font>				
				      <?php  }
			 } ?>		
	   			<br/><b>Cta.:</b> <?php  echo $val['nro_cuenta'].' - '.$val['nombre_cuenta']; ?>
	   		<?php if  ($val['codigo_auxiliar']!=''){ ?>	
	   			<br/><b>Aux.:</b> <?php  echo $val['codigo_auxiliar'].' - '.$val['nombre_auxiliar']; ?>
	   		<?php } ?>	
	   		
	   		<?php if  ($val['desc_orden']!=''){ ?>	
	   			<br/><b>OT.:</b> <?php  echo $val['desc_orden']; ?>
	   		<?php } ?>	
	   		<?php if  ($val['glosa']!=''){ ?>	
	   		    <br/><?php  echo trim($val['glosa']); ?>
	   		<?php } ?>
	   		<?php if  ($this->cabecera[0]['sw_tipo_cambio']=='si'){ ?>	
	   		   <br/><b>Tipo Cambio.:</b> <?php  echo number_format($val['tipo_cambio'], 2, '.', ','); ?>
	   		<?php } ?>	</div>
			</td>
			
		<?php 
		
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
			<td width="15%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_gasto']>0) {echo  number_format($val['importe_gasto'], 2, '.', ',');}else{echo  number_format($val['importe_recurso'], 2, '.', ',');} ?></span></td>
			<td width="15%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_debe']>0) {echo  number_format($val['importe_debe'], 2, '.', ',');} ?></span></td>
			<td width="15%" align="right" style="border-left: 0px solid #000;border-right: 1px solid #000;"><span><?php  if ($val['importe_haber']>0) {echo  number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
		<?php	
		  } 
		 else{  
		?>
		    <td width="11%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_gasto']>0) {echo  number_format($val['importe_gasto'], 2, '.', ',');}else{echo  number_format($val['importe_recurso'], 2, '.', ',');} ?></span></td>
			<td width="11%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_debe']>0) {echo   number_format($val['importe_debe'], 2, '.', ','); }?></span></td>
			<td width="11%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_haber']>0) {echo   number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
			<td width="11%" align="right" style="border-left: 0px solid #000;"><span><?php  if ($val['importe_debe_mb']>0) {echo   number_format($val['importe_debe_mb'], 2, '.', ',');} ?></span></td>
			<td width="11%" align="right" style="border-left: 0px solid #000;border-right: 1px solid #000;"><span><?php  if ($val['importe_haber_mb']>0) {echo   number_format($val['importe_haber_mb'], 2, '.', ',');} ?></span></td>
		
		<?php } ?>
</tr>
</table></font>