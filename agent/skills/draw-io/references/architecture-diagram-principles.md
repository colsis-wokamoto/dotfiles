# Architecture Diagram Principles

## 1. Communicate Before Decorating

- 図は「説明対象」を伝えるために作る。
- まず伝達したい判断材料を固定し、その後に装飾を加える。
- 1 図 1 メッセージを基本にし、用途ごとに図を分ける。

## 2. Keep Notation Consistent

- 同じ種類の要素は同じ図形、色、ラベル規則で表す。
- 線種や色で意味を分ける場合は凡例を必ず入れる。
- 矢印方向を統一し、曖昧な双方向表現を避ける。

## 3. Use Layered Views

- 俯瞰図から詳細図に掘り下げる構成を使う。
- 例: Context -> Container -> Network/Sequence/Deployment。
- 読者の役割に応じて情報量を調整する。

## 4. Improve Readability Systematically

- 要素の整列、余白、グルーピングで視線誘導を作る。
- 線交差を減らし、ラベルの重なりを防ぐ。
- テキストを読みやすいサイズで統一する。

## 5. AWS Diagram-Specific Guidance

- 境界を明確に描く: 外部、AWS Cloud、Account、VPC、Subnet、AZ。
- 公式 AWS アイコンとサービス名を使う。
- 通信やデータフローの意味を矢印・線種・凡例で定義する。
- 詳細化は段階的に行い、初回から過度に細かくしない。

## 6. Iterative Refinement Loop

1. 初版を作る。
2. 伝達失敗点を特定する。
3. レイアウト・命名・境界表現を修正する。
4. 変更差分を確認する。
5. 合意できるまで繰り返す。
