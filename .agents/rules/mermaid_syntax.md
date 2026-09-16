# GitHub-Compatible Mermaid Diagram Standards

Untuk memastikan diagram Mermaid dapat dirender dengan sempurna di GitHub Markdown tanpa *parse error*:

## 1. Flowchart (`flowchart TD / LR`)
- **Garis & Panah**:
  - Gunakan sintaks panah standar flowchart: `-->`, `---`, `-.->`, `==>`.
  - Jangan gunakan operator relasi UML / Class diagram (seperti `<|--` atau `<|..|`) di dalam `flowchart`.
  - Untuk implementasi interface / kontrak, gunakan: `RepoImpl -.->|Implements| RepoContract`.
- **Label & Arah Ganda**:
  - Hindari panah ganda berlabel `A <-->|Text| B` jika renderer ketat. Gunakan dua garis eksplisit:
    ```mermaid
    A -->|Dispatch Events| B
    B -->|Emit States| A
    ```

## 2. Sequence Diagram (`sequenceDiagram`)
- **Nama Partisipan**:
  - Hindari tanda kurung atau karakter khusus pada alias partisipan yang tidak dikutip (misal: gunakan `participant UI as Flutter App`, jangan `participant UI as Flutter App (Presentation)`).
- **Penomoran Otomatis**:
  - Gunakan perintah `autonumber` di baris pertama setelah `sequenceDiagram` untuk mempermudah pembacaan urutan langkah.
