//
//  ContentView.swift
//  TopKeyword
//
//  Created by bora on 2022/11/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                TextField("키워드", text: $text)
                    .foregroundColor(.primary)
                    .frame(height: 30)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
                
                Image(systemName: "magnifyingglass")
                
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
        }
        .padding(.horizontal)
    }
}

struct SearchView: View {
    let array = [
        "김서근", "포뇨", "하울", "소피아", "캐시퍼", "소스케",
        "치히로", "하쿠", "가오나시", "제니바", "카브", "마르클",
        "토토로", "사츠키", "지브리", "스튜디오", "캐릭터"
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                List {
                    ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
                        //                        searchText in Text(searchText)
                        searchText in VStack(alignment: .leading) {
                            TitleView(title: searchText, textSize: 20).foregroundColor(.accentColor)
                            Spacer()
                            HStack {
                                VStack {
                                    TitleView(title: "총 조회수", textSize: 15)
                                    Text("1")
                                }
                                Spacer()
                                VStack {
                                    TitleView(title: "문서수", textSize: 15)
                                    Text("1")
                                }
                                Spacer()
                                VStack {
                                    TitleView(title: "비율", textSize: 15)
                                    Text("1")
                                }
                                Spacer()
                                VStack {
                                    TitleView(title: "PC 검색량", textSize: 15)
                                    Text("1")
                                }
                                Spacer()
                                VStack {
                                    TitleView(title: "모바일 검색량", textSize: 15)
                                    Text("1")
                                }
                                
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                } //리스트의 스타일 수정
                .listStyle(PlainListStyle())
                //화면 터치시 키보드 숨김
                .onTapGesture {
                    //                    hideKeyboard()
                }
            }
            .navigationBarTitle("키워드 검색")
        }
    }
}

struct TitleView: View {
    var title: String
    var textSize: CGFloat
    var body: some View {
        Text(title).fontWeight(Font.Weight.semibold).font(Font.system(size: textSize))
    }
}
