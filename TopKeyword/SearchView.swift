//
//  SearchView.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/11.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @StateObject var viewModel = NaverApiViewModel()
    
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
    var check = false
    @State private var searchText = ""
    @StateObject var viewModel = NaverApiViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onSubmit {
                        viewModel.getBlog(query: searchText)
                        viewModel.getCafe(query: searchText)
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                List {
                    if searchText == "" {
                        EmptyView()
                    }
                    else {
                        VStack(alignment: .leading) {
                            Spacer()
                            TitleTextView(title: searchText, textSize: 20).foregroundColor(.accentColor)
                            Spacer()
                            Spacer()
                            HStack {
                                TypeView(title: "블로그글 수", content: "\(viewModel.blogs.total)", titleTextSize: 15)
                                Spacer()
                                TypeView(title: "총 조회수", content: "1", titleTextSize: 15)
                                Spacer()
                                TypeView(title: "PC 검색량", content: "1", titleTextSize: 15)
                            }
                            Spacer()
                            HStack {
                                TypeView(title: "카페글 수", content: "\(viewModel.cafes.total)", titleTextSize: 15)
                                Spacer()
                                TypeView(title: "비율", content: "1", titleTextSize: 15)
                                Spacer()
                                TypeView(title: "모바일 검색량", content: "1", titleTextSize: 15)

                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                }
//                리스트의 스타일 수정
//                .listStyle(PlainListStyle())
//                .listStyle(GroupedListStyle())
////                화면 터치시 키보드 숨김
//                .onTapGesture {
//                    hideKeyboard()
//                }
            }
            .navigationBarTitle("키워드 검색")
        }
    }

}

struct TypeView: View {
    var title: String
    var content: String
    var titleTextSize: CGFloat
    
    var body: some View {
        VStack{
            Spacer()
            TitleTextView(title: title, textSize: titleTextSize)
            Spacer()
            ContentTextView(content: content)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(5.0)
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
