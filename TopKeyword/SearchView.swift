//
//  SearchView.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/11.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                TextField("키워드", text: $text)
                    .foregroundColor(.primary)
                    .frame(height: 30)
                
                if !text.isEmpty {
                    Button(action: { self.text = ""}) {
                        Image(systemName: "")
                    }
                } else {
                    EmptyView()
                }
                
                Image(systemName: "")
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .cornerRadius(5.0)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
        }
        .padding(.horizontal)
    }
}

struct SearchView: View {
    let recentSearch: [String] = ["ios"]
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                List {
                    if recentSearch.isEmpty {
                        EmptyView()
                    }
                    else {
                        ForEach(recentSearch.filter{$0.hasPrefix(searchText) || searchText == ""}, id: \.self) {
                            searchText in VStack(alignment: .leading) {
                                TitleTextView(title: searchText, textSize: 20).foregroundColor(.accentColor)
                                Spacer()
                                HStack {
                                    VStack{
                                        TitleTextView(title: "총 조회수", textSize: 15)
                                        ContentTextView(content: "1")
                                    }
                                    Spacer()
                                    VStack{
                                        TitleTextView(title: "문서수", textSize: 15)
                                        ContentTextView(content: "1")
                                    }
                                    Spacer()
                                    VStack{
                                        TitleTextView(title: "비율", textSize: 15)
                                        ContentTextView(content: "1")
                                    }
                                    Spacer()
                                    VStack{
                                        TitleTextView(title: "PC 검색량", textSize: 15)
                                        ContentTextView(content: "1")
                                    }
                                    Spacer()
                                    VStack{
                                        TitleTextView(title: "모바일 검색량", textSize: 15)
                                        ContentTextView(content: "1")
                                    }
                                    
                                }
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                }
                //리스트의 스타일 수정
                .listStyle(PlainListStyle())
                //화면 터치시 키보드 숨김
                .onTapGesture {
                    //hideKeyboard()
                }
            }.navigationBarTitle("키워드 검색")
        }
    }
}

struct TitleTextView: View {
    var title: String
    var textSize: CGFloat
    var body: some View {
        Text(title).fontWeight(Font.Weight.semibold).font(Font.system(size: textSize))
    }
}

struct ContentTextView: View {
    var content: String
    var body: some View {
        Text(content)
    }
}
