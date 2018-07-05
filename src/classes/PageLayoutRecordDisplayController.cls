public class PageLayoutRecordDisplayController {
    @AuraEnabled
    public static PageLayout getPageLayoutMetadata(String pageLayoutName) {
        List<String> componentNameList = new List<String>{pageLayoutName};
        
        if (String.isBlank(pageLayoutName)) {
            return new PageLayout();
        }
        
        List<Metadata.Metadata> layouts =  
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);

        if (layouts.size() == 1) {
            return new PageLayout((Metadata.Layout) layouts[0]);
        }
        
        return new PageLayout();
    }
    
    public class PageLayout {
        @AuraEnabled
        public List<PageLayoutSection> Sections { get; set; }
        
        public PageLayout() {
            Sections = new List<PageLayoutSection>();
        }
        
        public PageLayout(Metadata.Layout layout) {
            this();

            for (Metadata.LayoutSection section : layout.layoutSections) {
                if (section.style != Metadata.LayoutSectionStyle.CustomLinks) {
                    Sections.add(new PageLayoutSection(section));
                }
            }
        }
    }
    
    public class PageLayoutSection {
        @AuraEnabled
        public List<PageLayoutSectionColumn> Columns { get; set; }
        
        @AuraEnabled
        public String Label { get; set; }
        
        public PageLayoutSection(Metadata.LayoutSection section) {
            Columns = new List<PageLayoutSectionColumn>();
            
            Label = section.label;
            
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                Columns.add(new PageLayoutSectionColumn(column));
            }
        }
    }
    
    public class PageLayoutSectionColumn {
        @AuraEnabled
        public List<PageLayoutField> Fields { get; set; }
        
        public PageLayoutSectionColumn(Metadata.LayoutColumn column) {
            Fields = new List<PageLayoutField>();
            
            if (column.layoutItems == null) {
                return;
            }

            for (Metadata.LayoutItem item : column.layoutItems) {
                Fields.add(new PageLayoutField(item));
            }
        }
    }
    
    public class PageLayoutField {
        @AuraEnabled
        public String APIName { get; set; }
        
        public PageLayoutField(Metadata.LayoutItem item) {
            APIName = item.field;
        }
    }
}