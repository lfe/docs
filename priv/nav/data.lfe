#(top-nav (
  (#(type dropdown)
   #(name "Code")
   #(links (
     (#(text "LFE") #(url "http://github.com/rvirding/lfe/"))
     (#(text "Supplemental Libraries") #(url "http://github.com/lfe/"))
     (#(text "Community Libraries") #(url "http://github.com/lfex/")))))
  (#(type link) #(text "Quick Start") #(url "/"))
  (#(type dropdown)
   #(name "Docs")
   #(links (
     (#(text "Install Guides") #(url "/"))
     (#(text "User Guides") #(url "/"))
     (#(text "Tutorials") #(url "/"))
     (#(text "Contributor Guides") #(url "/"))
     (#(text "Community Libraries") #(url "/")))))
  (#(type link) #(text "Resources") #(url "/"))
  (#(type link) #(text "Community") #(url "/"))
  (#(type link) #(text "Blog") #(url "/"))
  (#(type link) #(text "Main Site") #(url "/"))
  ; (#(type dynamic-dropdown
  ;  #(name "Versions")
  ;  #(mod docs-nav)
  ;  #(func get-versions)))
  (#(type dropdown)
   #(name "Versions")
   #(links (
     (#(text "0.6.0") #(url "/"))
     (#(text "0.7.0") #(url "/"))
     (#(text "0.10.1") #(url "/")))))))

#(bottom-nav-left (
  (#(type link) #(text "Tutorials") #(url "/"))
  (#(type link) #(text "Presentations") #(url "/"))
  (#(type link) #(text "History") #(url "/"))
  (#(type link) #(text "LFEX") #(url "/"))))

#(bottom-nav-right (
  (#(type link) #(text "Contributing") #(url "/"))
  (#(type link) #(text "Docs Tickets") #(url "/"))
  (#(type link) #(text ".plan") #(url "/"))
  (#(type link) #(text "Twitter") #(url "/"))))

#(left-nav (
  (#(type nav) #(text "") #(url ""))
  (#(type parent) #(text ""))
  (#(type subnav) #(text "") #(url ""))))
