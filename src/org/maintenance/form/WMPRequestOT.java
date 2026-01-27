/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, Ramiro Vergara, OFB Consulting, CHILE. 
 * Enhanced by Redhuan D. Oon (red1org@gmail.com). sponsored by Zeeshan@sysnova.com
*/
package org.maintenance.form;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;

import org.adempiere.webui.component.Button;
import org.adempiere.webui.component.Checkbox;
import org.adempiere.webui.component.Grid;
import org.adempiere.webui.component.GridFactory;
import org.adempiere.webui.component.Label;
import org.adempiere.webui.component.ListModelTable;
import org.adempiere.webui.component.ListboxFactory;
import org.adempiere.webui.component.Panel;
import org.adempiere.webui.component.Row;
import org.adempiere.webui.component.Rows;
import org.adempiere.webui.component.WListbox;
import org.adempiere.webui.editor.WDateEditor;
import org.adempiere.webui.editor.WSearchEditor;
import org.adempiere.webui.event.ValueChangeEvent;
import org.adempiere.webui.event.ValueChangeListener;
import org.adempiere.webui.event.WTableModelEvent;
import org.adempiere.webui.event.WTableModelListener;
import org.adempiere.webui.panel.ADForm;
import org.adempiere.webui.panel.CustomForm;
import org.adempiere.webui.panel.IFormController;
import org.adempiere.webui.panel.StatusBarPanel;
import org.compiere.model.MColumn;
import org.compiere.model.MDocType;
import org.compiere.model.MLookup;
import org.compiere.model.MLookupFactory;
import org.maintenance.component.MMPJobStandardResource;
import org.maintenance.component.MMPJobStandardTask;
import org.maintenance.component.MMPMaintain;
import org.maintenance.component.MMPOT;
import org.maintenance.component.MMPOTResource;
import org.maintenance.component.MMPOTTask;
import org.maintenance.model.X_MP_JobStandar;
import org.compiere.model.Query; 
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.DisplayType;
import org.compiere.util.Env;
import org.compiere.util.KeyNamePair;
import org.compiere.util.Msg;
import org.compiere.util.Trx;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zul.Borderlayout;
import org.zkoss.zul.Center;
import org.zkoss.zul.North;
import org.zkoss.zul.Separator;
import org.zkoss.zul.South;
/**
 * Solicitud OT Mantencion 
 *
 * @author  Fabian Aguilar
 * @version $Id: VMPRequestOT.java,v 1.2 2010/03/10 00:51:28$
 * 
 * Contributor : Fabian Aguilar - OFBConsulting - generate OT from request
 */
public class WMPRequestOT 
	implements IFormController, EventListener, WTableModelListener, ValueChangeListener
{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5322824600164192235L;

	private CustomForm form = new CustomForm();
	
	/**
	 *	Initialize Panel
	 *  @param WindowNo window
	 *  @param frame frame
	 */
	public  WMPRequestOT ()
	{
		log.info("Currency=" + m_C_Currency_ID);
		try
		{
			dynInit();
			zkInit();
			southPanel.appendChild(new Separator());
			southPanel.appendChild(statusBar);
			
		}
		catch(Exception e)
		{
			log.log(Level.SEVERE, "", e);
		}
	}	//	init

	/**	Window No			*/
	private int         m_WindowNo = 0;
	
	/**	Logger			*/
	private static CLogger log = CLogger.getCLogger(WMPRequestOT.class);

	
	private boolean     m_calculating = false;
	private int         m_C_Currency_ID = 0;
	
	//
	private Panel parameterPanel = new Panel();
	private Grid parameterLayout = GridFactory.newGridLayout();
	private Borderlayout mainLayout = new Borderlayout();
	private Panel allocationPanel = new Panel();
	private WListbox requestTable =  ListboxFactory.newDataTable();
	private Panel infoPanel = new Panel();
	private int         m_A_Asset_ID = 0;
	private int         m_Job_ID = 0;

	
	private Panel requestPanel = new Panel();
	private Label requestLabel = new Label();
	private Borderlayout requestLayout = new Borderlayout();
	private Label requestInfo = new Label();
	private Grid allocationLayout = GridFactory.newGridLayout();
	private Button ProcessButton = new Button();
	private Button searchButton = new Button();
	private Button VoidButton = new Button();
	private Button addButton = new Button();
	private Button EnableButton = new Button();
	private Button ChangeButton = new Button();
	private Label assetLabel = new Label();
	private Checkbox selectall = new Checkbox();
	private Label allocCurrencyLabel = new Label();
	private StatusBarPanel statusBar = new StatusBarPanel();
	private Label dateLabel = new Label();
	private WDateEditor dateField = new WDateEditor();
	private WSearchEditor assetSearch = null;
	private Label jobLabel = new Label();
	private WSearchEditor jobSearch = null;
	private Button jobButton = new Button();

	private Panel southPanel = new Panel();

	/**
	 *  Static Init
	 *  @throws Exception
	 */
	private void zkInit() throws Exception
	{
		form.appendChild(mainLayout);
		mainLayout.setWidth("99%");
		mainLayout.setHeight("100%");
		
		
		dateLabel.setText(Msg.getMsg(Env.getCtx(), "Date"));
		
		
		//
		parameterPanel.appendChild(parameterLayout);
		allocationPanel.appendChild(allocationLayout);
		requestLabel.setText("Request List");
		requestPanel.appendChild(requestLayout);
	
		requestInfo.setText(".");
		
		ProcessButton.setLabel(Msg.getMsg(Env.getCtx(), "Generate OT"));
		ProcessButton.addActionListener(this);
		VoidButton.setLabel(Msg.getMsg(Env.getCtx(), "Void Request"));
		VoidButton.addActionListener(this);
		searchButton.setLabel(Msg.getMsg(Env.getCtx(), "Search"));
		searchButton.addActionListener(this);
		addButton.setLabel(Msg.getMsg(Env.getCtx(), "Select"));
		addButton.addActionListener(this);
		EnableButton.setLabel(Msg.getMsg(Env.getCtx(), "Enable Editing"));
		EnableButton.addActionListener(this);
		ChangeButton.setLabel(Msg.getMsg(Env.getCtx(), "set Date"));
		ChangeButton.addActionListener(this);
		jobButton.setLabel("set Standard");
		jobButton.addActionListener(this);
		jobLabel.setText("Standard");
		
		assetLabel.setText(Msg.translate(Env.getCtx(), "A_Asset_ID"));
		selectall.setText(Msg.getMsg(Env.getCtx(), "Sellect all"));
		selectall.addActionListener(this);
		allocCurrencyLabel.setText(".");
		
		North north = new North();
		north.setStyle("border: none");
		mainLayout.appendChild(north);
		north.appendChild(parameterPanel);
		Rows rows = null;
		Row row = null;
		
		parameterLayout.setWidth("800px");
		rows = parameterLayout.newRows();
		row = rows.newRow();
		row.appendChild(dateLabel.rightAlign());
		row.appendChild(dateField.getComponent());
		row.appendChild(ChangeButton);
		row.appendChild(assetLabel.rightAlign());
		row.appendChild(assetSearch.getComponent());
		row.appendChild(selectall);
		row.appendChild(jobLabel.rightAlign());
		row.appendChild(jobSearch.getComponent());
		row.appendChild(jobButton);
		
		South south = new South();
		south.setStyle("border: none");
		mainLayout.appendChild(south);
		south.appendChild(southPanel);
		southPanel.appendChild(allocationPanel);
		allocationPanel.appendChild(allocationLayout);
		allocationLayout.setWidth("400px");
		rows = allocationLayout.newRows();
		row = rows.newRow();
		row.appendChild(VoidButton);
		row.appendChild(ProcessButton);
	
		requestPanel.appendChild(requestLayout);
		requestPanel.setWidth("100%");
		requestPanel.setHeight("100%");
		requestLayout.setWidth("100%");
		requestLayout.setHeight("100%");
		requestLayout.setStyle("border: none");
		
		
		north = new North();
		north.setStyle("border: none");
		requestLayout.appendChild(north);
		north.appendChild(requestLabel);
		south = new South();
		south.setStyle("border: none");
		requestLayout.appendChild(south);
		south.appendChild(requestInfo.rightAlign());
		Center center = new Center();
		requestLayout.appendChild(center);
		center.appendChild(requestTable);
		requestTable.setWidth("99%");
		// Don't set height - vflex is set by ListboxFactory and Center handles sizing
		center.setStyle("border: none");
		//
		center = new Center();
		mainLayout.appendChild(center);
		center.appendChild(requestPanel);//infoPanel
		/*
		infoPanel.setStyle("border: none");
		infoPanel.setWidth("100%");
		infoPanel.setHeight("100%");
		
		north = new North();
		north.setStyle("border: none");
		north.setHeight("90%");
		infoPanel.appendChild(north);
		north.appendChild(requestPanel);
		north.setSplittable(true);*/
		
		
	}   //  jbInit

	
	/**
	 *  Dynamic Init (prepare dynamic fields)
	 *  @throws Exception if Lookups cannot be initialized
	 */
	private void dynInit() throws Exception
	{
		
	//  Asset
		int AD_Column_ID = MColumn.getColumn_ID("MP_Maintain","A_Asset_ID");        //  MP_Maintain.A_Asset_ID
		MLookup lookupBP = MLookupFactory.get (Env.getCtx(), m_WindowNo, 0, AD_Column_ID, DisplayType.Search);
		assetSearch = new WSearchEditor("A_Asset_ID", true, false, true, lookupBP);
		assetSearch.addValueChangeListener(this);
	
	// jobstandard
		AD_Column_ID = MColumn.getColumn_ID("MP_Maintain","MP_JobStandar_ID");        //  MP_Maintain.A_Asset_ID
		MLookup lookupjob = MLookupFactory.get (Env.getCtx(), m_WindowNo, 0, AD_Column_ID, DisplayType.Search);
		jobSearch = new WSearchEditor("MP_JobStandar_ID", true, false, true, lookupjob);
		jobSearch.addValueChangeListener(this);
		
	//  Date set to Login Date
		dateField.setValue(Env.getContextAsDate(Env.getCtx(), "#Date"));
		//  Translation
		statusBar.setStatusLine("Select the maintenance, change the date predicted or directly generate OT");
		statusBar.setStatusDB("");
		loadMPs();
		

	}   //  dynInit

	/**
	 *  Load Business Partner Info
	 *  - Payments
	 *  - Invoices
	 */
	private void loadMPs ()
	{		
		//log.config("Instance_ID=" +Instance_ID);
		//  Need to have both values
		
		
		/********************************
		 *  Load request table
		 *      1-TrxDate, 2-DocumentNo, (3-Currency, 4-PayAmt,)
		 *      5-ConvAmt, 6-ConvOpen, 7-Allocated
		 */
		List<List<Object>> data = new ArrayList<List<Object>>();
		StringBuffer sql = new StringBuffer("select rt.DATEDOC,rt.DATEREQUIRED,rt.DOCUMENTNO,rt.MP_OT_REQUEST_ID, rt.AD_Org_ID, rt.AD_User_ID, "+
			"rt.A_Asset_ID, rt.MP_JOBSTANDAR_ID, rt.Description, u.name, a.name as AssetName, jo.name as jobName,rl.name as PriorityRule, rt.OT_Request_Type "+
			"from MP_OT_REQUEST rt "+
			"inner join AD_User u on (rt.AD_User_ID=u.AD_User_ID) "+
			"inner join A_Asset a on (rt.A_Asset_ID=a.A_Asset_ID) "+
			"left outer join MP_JOBSTANDAR jo on (rt.MP_JOBSTANDAR_ID=jo.MP_JOBSTANDAR_ID) " +
			"inner join AD_Ref_List rl on (rt.PriorityRule=rl.value and rl. AD_Reference_ID=154) " +
			"where rt.DocStatus='WC' and rt.processed='Y'");
		
		log.config("request=" + sql.toString());
		try
		{
			PreparedStatement pstmt = DB.prepareStatement(sql.toString(), null);
			//pstmt.setInt(1, Instance_ID);
			String tipo=new String();
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				List<Object> line = new ArrayList<Object>();
				line.add(Boolean.FALSE);       //  0-Selection
				if(rs.getString(14).equals("RV"))
					tipo="Revision";
				if(rs.getString(14).equals("RP"))
					tipo="Reparacion";
				if(rs.getString(14).equals("CN"))
					tipo="Completar Niveles";
				line.add(tipo); // 1-tipo solicitud
				line.add(rs.getTimestamp(2));       //  2-fecha solicitada
				KeyNamePair pp = new KeyNamePair(rs.getInt(4), rs.getString(3));
				line.add(pp); //  3-numero documento
				line.add(rs.getTimestamp(1));  //  4-fecha doc
				KeyNamePair pp2 = new KeyNamePair(rs.getInt(6), rs.getString(10));
				line.add(pp2);  //  5-user
				KeyNamePair pp3 = new KeyNamePair(rs.getInt(7), rs.getString(11));
				line.add(pp3);      //  6-asset
				line.add(rs.getString(9)); 				//  7-description
				line.add(rs.getString(13)); //8-prioridad
				KeyNamePair pp4 = new KeyNamePair(rs.getInt(8), rs.getString(12));
				line.add(pp4);   //9 - jobstandard
				//
				data.add(line);
			}
			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			log.log(Level.SEVERE, sql.toString(), e);
		}
		//  Remove previous listeners
		requestTable.clear();
		requestTable.getModel().removeTableModelListener(this);
		//  Header Info
		List<String> columnNames = new ArrayList<String>();
		columnNames.add(Msg.getMsg(Env.getCtx(), "Selected"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Type"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Date Programed"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Request No"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Date Request"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "AD_User_ID"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Asset"));
		columnNames.add(Msg.translate(Env.getCtx(), "Description"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Priority"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Standard Job"));

		
		//  Set Model
		ListModelTable modelP = new ListModelTable(data);
		modelP.addTableModelListener(this);
		requestTable.setData(modelP,columnNames);
		//
		int i = 0;
		requestTable.setColumnClass(i++, Boolean.class, false);         //  0-Selection
		requestTable.setColumnClass(i++, String.class, true);			//1-tipo solicitud
		requestTable.setColumnClass(i++, Timestamp.class, false);         //  2-fecha solicitada
		requestTable.setColumnClass(i++, String.class, true);           //  3-numero documento
		requestTable.setColumnClass(i++, Timestamp.class, true);        //  4-fecha doc
		requestTable.setColumnClass(i++, String.class, true);       //  5-user
		requestTable.setColumnClass(i++, String.class, true);       //  6-asset
		requestTable.setColumnClass(i++, String.class, true);      //  7-description
		requestTable.setColumnClass(i++, String.class, true);		//8-prioridad
		requestTable.setColumnClass(i++, String.class, true);      //  9-jobstandard


		
		

		//  Table UI
		requestTable.autoSize();
		
		requestTable.setColumnReadOnly(1, false);


		
		calculate();
	}   //  loadBPartner


	
	/**************************************************************************
	 *  Action Listener.
	 *  - MultiCurrency
	 *  - Allocate
	 *  @param e event
	 */
	public void onEvent(Event e)
	{
		log.config("");
		if (e.getTarget().equals(ProcessButton))
		{
			//ProcessButton.setEnabled(false);
			saveData();

			
		}
		else if (e.getTarget().equals(jobButton)){
			ListModelTable request = requestTable.getModel();
			int rows = request.getRowCount();
			X_MP_JobStandar job=new X_MP_JobStandar(Env.getCtx(), m_Job_ID,null);
			for (int i = 0; i < rows; i++)
			{
				if (((Boolean)request.getValueAt(i, 0)).booleanValue())
				{
					KeyNamePair pp = new KeyNamePair(job.getMP_JobStandar_ID(), job.getName());
					request.setValueAt(pp, i, 9);
					
				}
			}
			
		}
		else if (e.getTarget().equals(VoidButton)){
			voidData();
		}
		else if (e.getTarget().equals(ChangeButton)){
			ProcessButton.setEnabled(true);
			//updating rows selected
			ListModelTable request = requestTable.getModel();
			int rows = request.getRowCount();
			Timestamp DateTrx = (Timestamp)dateField.getValue();
			for (int i = 0; i < rows; i++)
			{
				if (((Boolean)request.getValueAt(i, 0)).booleanValue())
				{
					
					request.setValueAt(DateTrx, i, 2);
					
				}
			}
		}
		else if (e.getTarget().equals(selectall)){
			ListModelTable request = requestTable.getModel();
			int rows = request.getRowCount();
			for (int i = 0; i < rows; i++)
			{		
				if(m_A_Asset_ID==0)
					request.setValueAt(selectall.isSelected(), i, 0);
				else{
					KeyNamePair pp = (KeyNamePair)request.getValueAt(i, 6);//Asset
					int Asset_ID=pp.getKey();
					if(Asset_ID==m_A_Asset_ID)
						request.setValueAt(selectall.isSelected(), i, 0);
				}
				
			}
		}
	}   //  actionPerformed

	/**
	 *  Table Model Listener.
	 *  - Recalculate Totals
	 *  @param e event
	 */
	public void tableChanged(WTableModelEvent e)
	{
		boolean isUpdate = (e.getType() ==  WTableModelEvent.CONTENTS_CHANGED);
		//  Not a table update
		if (!isUpdate)
		{
			calculate();
			return;
		}
	

		/**
		 *  Setting defaults
		 */
		if (m_calculating)  //  Avoid recursive calls
			return;
		m_calculating = true;
		

		m_calculating = false;
		calculate();
	}   //  tableChanged

	/**
	 *  Calculate Allocation info
	 */
	private void calculate ()
	{
		log.config("");
		//
		DecimalFormat format = DisplayType.getNumberFormat(DisplayType.Amount);
		Timestamp allocDate = null;
		
		
	}   //  calculate

	/**
	 *  Vetoable Change Listener.
	 *  - Business Partner
	 *  - Currency
	 * 	- Date
	 *  @param e event
	 */
	public void valueChange (ValueChangeEvent e)
	{
		String name = e.getPropertyName();
		Object value = e.getNewValue();
		log.config(name + "=" + value);
		if (name.equals("A_Asset_ID"))
		{
			assetSearch.setValue(value);
			if (value != null)
			m_A_Asset_ID = ((Integer)value).intValue();
			
		}
		else if(name.equals("MP_JobStandar_ID"))
		{
			jobSearch.setValue(value);
			if (value != null)
			m_Job_ID = ((Integer)value).intValue();
		}
		
	}   //  vetoableChange

	
	/**************************************************************************
	 *  Save Data
	 */
	private void saveData()
	{
		
		ListModelTable request = requestTable.getModel();
		int rows = request.getRowCount();
		Timestamp DateTrx = (Timestamp)dateField.getValue();
		Trx trx = Trx.get(Trx.createTrxName("AL"), true);
		for (int i = 0; i < rows; i++)
		{
			if (((Boolean)request.getValueAt(i, 0)).booleanValue())
			{
				KeyNamePair pp = (KeyNamePair)request.getValueAt(i, 3);//Req
				int Req_ID=pp.getKey();
				pp = (KeyNamePair)request.getValueAt(i, 6);//Asset
				int Asset_ID=pp.getKey();
				Timestamp Datetrx =(Timestamp)request.getValueAt(i, 2);//Date
				String description =(String)request.getValueAt(i, 7);//Description
				
				
				int job_id=0;
				if(request.getValueAt(i, 9)!=null){
					pp=(KeyNamePair)request.getValueAt(i, 9);//job
					job_id=pp.getKey();
				}
				   
				if(!createOT(job_id,Datetrx,description,Asset_ID, Req_ID)){
						log.log(Level.SEVERE, "OT not created #" + i);
						continue;
				}
				
				String sql="Update MP_OT_REQUEST set DocStatus='AP',MP_JobStandar_ID="+job_id
				+ " where MP_OT_REQUEST_ID="+Req_ID; 
				
				DB.executeUpdate(sql);
				
				
			}
		}
		loadMPs ();
	}   //  saveData
	
	
	/**************************************************************************
	 *  Void Data
	 */
	private void voidData()
	{
		
		ListModelTable request = requestTable.getModel();
		int rows = request.getRowCount();
		Trx trx = Trx.get(Trx.createTrxName("AL"), true);
		for (int i = 0; i < rows; i++)
		{
			if (((Boolean)request.getValueAt(i, 0)).booleanValue())
			{
				KeyNamePair pp = (KeyNamePair)request.getValueAt(i, 3);//Req
				int Req_ID=pp.getKey();
				
				String sql="Update MP_OT_REQUEST set DocStatus='VO'"
				+ " where MP_OT_REQUEST_ID="+Req_ID; 
				
				DB.executeUpdate(sql);
				
				
			}
		}
		loadMPs ();
	}   //  voidDate
	
	public boolean createOT(int Job_ID, Timestamp Datetrx,String description,int Asset_ID, int Req_ID ){
		
		//creation header OT
		MMPOT newOT=new MMPOT(Env.getCtx(), 0,null);
		newOT.setDateTrx(Datetrx);
		newOT.setDescription(description);
		newOT.setA_Asset_ID(Asset_ID);
		newOT.setMP_JobStandar_ID(Job_ID);
		newOT.setDocStatus("DR");
		newOT.setDocAction("CO");
		newOT.setMP_OT_Request_ID(Req_ID);
		newOT.setC_DocType_ID(MDocType.getOfDocBaseType(Env.getCtx(), "MOF")[0].getC_DocType_ID());
		if(!newOT.save())//create new OT
			return false;
		
		if(!createOTTaskDetail(Job_ID,newOT))
			return false;
		
		return true;
	}
	
	public void lookChilds(int MP_ID, MMPOT OT){
		
/*		String sql = "select mp_maintain_id from mp_maintain where ischild='Y' and MP_MAINTAINPARENT_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,MP_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				createOTTaskDetail(rs.getInt(1),OT);
				lookChilds(rs.getInt(1),OT);
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}*/
		List <MMPMaintain> list = new Query(Env.getCtx(),MMPMaintain.Table_Name,MMPMaintain.COLUMNNAME_MP_MaintainParent_ID+"=? AND "
				+MMPMaintain.COLUMNNAME_IsChild+"=?", null)
			.setParameters(MP_ID,'Y').list();
			
			for (MMPMaintain main:list){
				createOTTaskDetail(main.getMP_Maintain_ID(),OT);
				lookChilds(main.getMP_Maintain_ID(),OT);
			}
		
	}
	
	public boolean createOTTaskDetail(int Job_ID, MMPOT OT){
		
/*		String sql = "select * from MP_JOBSTANDAR_TASK where MP_JOBSTANDAR_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,Job_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				X_MP_OT_Task ta = new X_MP_OT_Task(Env.getCtx(), 0,null);
				//ta.setMP_Maintain_ID(MP_ID);
				ta.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				ta.setMP_OT_ID(OT.getMP_OT_ID());
				ta.setDescription(rs.getString("Description"));
				ta.setDuration(rs.getBigDecimal("Duration"));
				ta.setC_UOM_ID(rs.getInt("C_UOM_ID"));
				ta.setStatus(ta.STATUS_NotStarted);
				ta.saveEx();
				
				createOTResourceDetail(rs.getInt("MP_JOBSTANDAR_TASK_ID"),ta.getMP_OT_Task_ID());
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}*/
		List <MMPJobStandardTask> list = new Query(Env.getCtx(),MMPJobStandardTask.Table_Name,
				MMPJobStandardTask.COLUMNNAME_MP_JobStandar_ID+"=?",null)
		.setParameters(Job_ID).list();
		
		for (MMPJobStandardTask task:list){
			MMPOTTask ta = new MMPOTTask(Env.getCtx(), 0,null);
			//ta.setMP_Maintain_ID(MP_ID);
			ta.setAD_Org_ID(task.getAD_Org_ID());
			ta.setMP_OT_ID(OT.getMP_OT_ID());
			ta.setDescription(task.getDescription());
			ta.setDuration(task.getDuration());
			ta.setC_UOM_ID(task.getC_UOM_ID());
			ta.setStatus(ta.STATUS_NotStarted);
			ta.saveEx();
			
			createOTResourceDetail(task.getMP_JobStandar_Task_ID(),ta.getMP_OT_Task_ID());
		}
		
		return true;
		
	}
	public boolean createOTResourceDetail(int oldTask_ID, int newTask_ID){
		
/*		String sql = "select * from MP_JOBSTANDAR_RESOURCE where MP_JOBSTANDAR_TASK_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,oldTask_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				X_MP_OT_Resource re=new X_MP_OT_Resource(Env.getCtx(), 0,null);
				re.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				re.setMP_OT_Task_ID(newTask_ID);
				re.setCostAmt(rs.getBigDecimal("CostAmt"));
				re.setS_Resource_ID(rs.getInt("S_Resource_ID"));
				re.setM_BOM_ID(rs.getInt("M_BOM_ID"));
				re.setResourceQty(rs.getBigDecimal("RESOURCEQTY"));
				re.setResourceType(rs.getString("RESOURCETYPE"));
				re.set_ValueOfColumn("M_Product_ID", rs.getInt("M_Product_ID"));
				re.saveEx();
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		*/
		List<MMPJobStandardResource> list = new Query(Env.getCtx(),MMPJobStandardResource.Table_Name,MMPJobStandardResource.COLUMNNAME_MP_JobStandar_Task_ID+"=?",null)
		.setParameters(oldTask_ID)
		.list();
		for (MMPJobStandardResource job:list){
			MMPOTResource re=new MMPOTResource(Env.getCtx(), 0,null);
			re.setAD_Org_ID(job.getAD_Org_ID());
			re.setMP_OT_Task_ID(newTask_ID);
			re.setCostAmt(job.getCostAmt());
			re.setS_Resource_ID(job.getS_Resource_ID());
			re.setPP_Product_BOM_ID(job.getPP_Product_BOM_ID());
			re.setResourceQty(job.getResourceQty());
			re.setResourceType(job.getResourceType());
			re.set_ValueOfColumn(job.COLUMNNAME_M_Product_ID, job.getM_Product_ID());
			re.saveEx();
		}
		return true;
		
	}
	
	
	/**
	 * Called by org.adempiere.webui.panel.ADForm.openForm(int)
	 * @return
	 */
	public ADForm getForm()
	{
		return form;
	}

}   //  VAllocation
