//
//  GraveFilterView.swift
//  GraveFinder
//
//  Created by Shafigh Khalili on 2020-12-19.
//

import SwiftUI

struct GraveFilterView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Action Sheet"), message: Text("Choose Option"), buttons: [
            .default(Text("Save")),
            .default(Text("Delete")),
            .destructive(Text("Cancel"))
        ])
        
    }
}

struct GraveFilterView_Previews: PreviewProvider {
    static var previews: some View {
        GraveFilterView()
    }
}
