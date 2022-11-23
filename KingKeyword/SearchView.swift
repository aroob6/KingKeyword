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
                TextField("키워드 검색", text: $text)
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
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
        }
        .padding(.horizontal)
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var naverApiviewModel = NaverApiViewModel()
    @StateObject var naverAdApiviewModel = NaverAdApiViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onSubmit {
                        naverApiviewModel.getBlog(query: searchText)
                        naverApiviewModel.getCafe(query: searchText)
                        naverAdApiviewModel.getRelKwdStat(query: searchText)
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                VStack {
                    if searchText == "" {
                        EmptyView()
                    }
                    else {
                        List {
                            VStack() {
                                let blog = naverApiviewModel.blogs.total
                                let cafe = naverApiviewModel.cafes.total
                                let allDoc = blog + cafe
                                let pcAmount = naverAdApiviewModel.keywordList.keywordList[0].monthlyPcQcCnt.num
                                let mobileAmount = naverAdApiviewModel.keywordList.keywordList[0].monthlyMobileQcCnt.num
                                let allSearch = pcAmount + mobileAmount
                                let blogPersent = Double(blog) / Double(allSearch)
                                let cafePersent = Double(cafe) / Double(allSearch)
                                
                                Spacer()
                                HStack {
                                    TitleTextView(title: searchText, textSize: 20).foregroundColor(.black)
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        TitleTextView(title: "블로그 비율: \(String(format: "%.3f", blogPersent))", textSize: 20).foregroundColor(.green)
                                        TitleTextView(title: "카페 비율: \(String(format: "%.3f", cafePersent))", textSize: 20).foregroundColor(.brown)
                                    }
                                    Spacer()
                                }
                                Spacer()
                                Spacer()
                                HStack {
                                    TypeView(title: "블로그글 수", content: "\(blog.numberFormatter())", titleTextSize: 15)
                                    Spacer()
                                    TypeView(title: "카페글 수", content: "\(cafe.numberFormatter())", titleTextSize: 15)
                                    Spacer()
                                    TypeView(title: "총 문서 수", content: "\(allDoc.numberFormatter())", titleTextSize: 15)
                                }
                                Spacer()
                                HStack {
                                    TypeView(title: "PC 검색수", content: "\(pcAmount.numberFormatter())", titleTextSize: 15)
                                    Spacer()
                                    TypeView(title: "모바일 검색수", content: "\(mobileAmount.numberFormatter())", titleTextSize: 15)
                                    Spacer()
                                    TypeView(title: "총 검색수", content: "\(allSearch.numberFormatter())", titleTextSize: 15)

                                }
                                
                                Divider().padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
                                
                                //연관검색어 뷰
                                VStack() {
                                    Spacer()
                                    HStack {
                                        TitleTextView(title: "연관키워드", textSize: 20).foregroundColor(.black)
                                        TitleTextView(title: "10개까지 노출", textSize: 10).foregroundColor(.gray)
                                    }
                                    ScrollView(.horizontal) {
                                        LazyHStack {
                                            ForEach(0 ..< naverAdApiviewModel.keywordList.keywordList.count, id: \.self) { index in
                                                if naverAdApiviewModel.keywordList.keywordList.count > 1 {
                                                    
                                                    Text("\(naverAdApiviewModel.keywordList.keywordList[index].relKeyword)")
                                                        .font(Font.system(size: 15))
                                                        .padding()
                                                        .background(Color(.secondarySystemBackground))
                                                        
                                                }
                                                else {
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                
                                //설명 뷰
                                ExplanView().padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            }
                        }
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarTitle("킹키워드")
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
    }
}
struct TitleTextView: View {
    var title: String
    var textSize: CGFloat
    var body: some View {
        Text(title).fontWeight(Font.Weight.semibold)
    }
}

struct ContentTextView: View {
    var content: String
    var body: some View {
        Text(content)
    }
}

struct ExplanView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TitleTextView(title: "PC/모바일 검색 수 - 최근 한 달간 네이버를 이용한 사용자가 PC 및 모바일 에서 해당 키워드를 검색한 횟수\n\n블로그/카페 글 수 - 네이버 총 검색 결과 개수", textSize: 8).foregroundColor(.gray).minimumScaleFactor(0.5)
        }
    }
}
